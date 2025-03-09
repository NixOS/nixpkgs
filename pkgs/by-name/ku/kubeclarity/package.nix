{ lib
, btrfs-progs
, buildGoModule
, fetchFromGitHub
, lvm2
, pkg-config
, stdenv
}:

buildGoModule rec {
  pname = "kubeclarity";
  version = "2.23.3";

  src = fetchFromGitHub {
    owner = "openclarity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MC9GeJeVG7ROkpmOW2HD/fWMMnHo43q4Du9MzWTk2cg=";
  };

  vendorHash = "sha256-JY64fqzNBpo9Jwo8sWsWTVVAO5zzwxwXy0A2bgqJHuU=";

  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
    lvm2
  ];

  sourceRoot = "${src.name}/cli";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/kubeclarity
  '';

  meta = with lib; {
    description = "Kubernetes runtime scanner";
    mainProgram = "kubeclarity";
    longDescription = ''
      KubeClarity is a vulnerabilities scanning and CIS Docker benchmark tool that
      allows users to get an accurate and immediate risk assessment of their
      kubernetes clusters. Kubei scans all images that are being used in a
      Kubernetes cluster, including images of application pods and system pods.
    '';
    homepage = "https://github.com/openclarity/kubeclarity";
    changelog = "https://github.com/openclarity/kubeclarity/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
