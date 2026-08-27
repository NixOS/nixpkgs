{
  callPackage,
  dockerTools,
  stdenv,
  testers,
}:

let
  imageInfo = builtins.fromJSON (builtins.readFile ./podman-images.json);

  inherit (imageInfo) imageName imageTag;

  system = if stdenv.hostPlatform.isDarwin then "aarch64-linux" else stdenv.hostPlatform.system;
  imagePin = imageInfo.images.${system};

  ramalamaImage = dockerTools.pullImage {
    inherit imageName;
    inherit (imageInfo) imageDigest;
    inherit (imagePin) hash arch;
    finalImageTag = imageTag;
  };

  port = 18082;
in
testers.runNixOSTest {
  name = "ramalama-podman-test";

  nodes.machine =
    { pkgs, ... }:
    let
      serveTestRunner = (pkgs.callPackage ./common.nix { }).mkServeTestRunner {
        model = pkgs.callPackage ./llama-cpp-model.nix { };
        inherit port;
        host = "0.0.0.0";
        image = "${imageName}:${imageTag}";
        extraCheck = ''
          podman ps --format '{{.Image}}' | grep -Fx ${imageName}:${imageTag}
        '';
      };
    in
    {
      # Not strictly required on Linux, but on darwin case-insensitive file
      # systems, libxt_mark.so may be renamed to libxt_mark.so~nix~case~hack~1
      # which breaks netavark networking inside the machine. Workaround with
      # nftables.
      networking.nftables.enable = true;

      virtualisation = {
        cores = 2;
        # Podman expands the pinned image under /var/lib/containers/storage.
        diskSize = 10 * 1024;
        podman.enable = true;
      };

      environment.systemPackages = [
        serveTestRunner
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("podman load -i ${ramalamaImage}")

    machine.succeed("ramalama-serve-test")
  '';
}
