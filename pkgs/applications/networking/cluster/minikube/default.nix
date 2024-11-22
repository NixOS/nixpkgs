{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, pkg-config
, which
, libvirt
, vmnet
, withQemu ? false
, qemu
, makeWrapper
, OVMF
}:

buildGoModule rec {
  pname = "minikube";
  version = "1.34.0";

  vendorHash = "sha256-gw5Ol7Gp26KyIaiMvwik8FJpABpMT86vpFnZnAJ6hhs=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-Z7x3MOQUF3a19X4SSiIUfSJ3xl3482eKH700m/9pqcU=";
  };
  postPatch =
    (
      lib.optionalString (withQemu && stdenv.hostPlatform.isDarwin) ''
        substituteInPlace \
          pkg/minikube/registry/drvs/qemu2/qemu2.go \
          --replace "/usr/local/opt/qemu/share/qemu" "${qemu}/share/qemu" \
          --replace "/opt/homebrew/opt/qemu/share/qemu" "${qemu}/share/qemu"
      ''
    ) + (
      lib.optionalString (withQemu && stdenv.hostPlatform.isLinux) ''
        substituteInPlace \
          pkg/minikube/registry/drvs/qemu2/qemu2.go \
          --replace "/usr/share/OVMF/OVMF_CODE.fd" "${OVMF.firmware}" \
          --replace "/usr/share/AAVMF/AAVMF_CODE.fd" "${OVMF.firmware}"
      ''
    );

  nativeBuildInputs = [ installShellFiles pkg-config which makeWrapper ];

  buildInputs = if stdenv.hostPlatform.isDarwin then [ vmnet ] else if stdenv.hostPlatform.isLinux then [ libvirt ] else null;

  buildPhase = ''
    make COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/minikube -Dt $out/bin

    wrapProgram $out/bin/minikube --set MINIKUBE_WANTUPDATENOTIFICATION false
    export HOME=$PWD

    for shell in bash zsh fish; do
      $out/bin/minikube completion $shell > minikube.$shell
      installShellCompletion minikube.$shell
    done
  '';

  meta = with lib; {
    homepage = "https://minikube.sigs.k8s.io";
    description = "Tool that makes it easy to run Kubernetes locally";
    mainProgram = "minikube";
    license = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester atkinschang Chili-Man ];
  };
}
