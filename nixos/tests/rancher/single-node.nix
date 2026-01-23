# A test that runs a single node rancher cluster and verifies a pod can run
{
  pkgs,
  lib,
  rancherDistro,
  rancherPackage,
  serviceName,
  disabledComponents,
  coreImages,
  vmResources,
  ...
}:
let
  imageEnv = pkgs.buildEnv {
    name = "${rancherDistro}-pause-image-env";
    paths = with pkgs; [
      tini
      (lib.hiPrio coreutils)
      busybox
    ];
  };
  pauseImage = pkgs.dockerTools.buildLayeredImage {
    name = "test.local/pause";
    tag = "local";
    contents = imageEnv;
    config.Entrypoint = [
      "/bin/tini"
      "--"
      "/bin/sleep"
      "inf"
    ];
  };
  testPodYaml = pkgs.writeText "test.yaml" ''
    apiVersion: v1
    kind: Pod
    metadata:
      name: test
    spec:
      containers:
      - name: test
        image: test.local/pause:local
        imagePullPolicy: Never
        command: ["sh", "-c", "sleep inf"]
  '';
in
{
  name = "${rancherPackage.name}-single-node";

  nodes.machine =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kubectl
        gzip
      ];
      environment.sessionVariables.KUBECONFIG = "/etc/rancher/${rancherDistro}/${rancherDistro}.yaml";

      virtualisation = vmResources;

      services.${rancherDistro} = {
        enable = true;
        role = "server";
        package = rancherPackage;
        disable = disabledComponents;
        images = coreImages ++ [ pauseImage ];
        extraFlags = [
          "--pause-image test.local/pause:local"
        ];
      };

      users.users = {
        noprivs = {
          isNormalUser = true;
          description = "Can't access ${rancherDistro} by default";
          password = "*";
        };
      };
    };

  testScript = # python
    ''
      start_all()

      machine.wait_for_unit("${serviceName}")
      machine.succeed("kubectl cluster-info")
      machine.fail("sudo -u noprivs kubectl cluster-info")
      ${lib.optionalString (rancherDistro == "k3s") ''
        machine.succeed("k3s check-config")
      ''}

      # Also wait for our service account to show up; it takes a sec
      machine.wait_until_succeeds("kubectl get serviceaccount default")
      machine.succeed("kubectl apply -f ${testPodYaml}")
      machine.succeed("kubectl wait --for 'condition=Ready' pod/test --timeout=180s")
      machine.succeed("kubectl delete -f ${testPodYaml}")

      # regression test for #176445
      machine.fail("journalctl -o cat -u ${serviceName}.service | grep 'ipset utility not found'")

      with subtest("Run ${rancherDistro}-killall"):
          # Call the killall script with a clean path to assert that
          # all required commands are wrapped
          output = machine.succeed("PATH= ${rancherPackage}/bin/${rancherDistro}-killall.sh 2>&1 | tee /dev/stderr")
          t.assertNotIn("command not found", output, "killall script contains unknown command")

          # Check that killall cleaned up properly
          machine.fail("systemctl is-active ${serviceName}.service")
          machine.wait_until_fails("systemctl list-units | grep containerd", timeout=5)
          machine.fail("ip link show | awk -F': ' '{print $2}' | grep -e flannel -e cni0")
          machine.fail("ip netns show | grep cni-")
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
