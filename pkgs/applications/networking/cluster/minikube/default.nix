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
  version = "1.33.0";

  vendorHash = "sha256-eFIo9C9AEZksQolMlWKPJR2WWpU7Yu4eJb1OBwdqGhI=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-4OSChPgUD1oYnChAi7r2jgZpplR9ZaHpHPiTS6jSpME=";
  };
  postPatch =
    (
      lib.optionalString (withQemu && stdenv.isDarwin) ''
        substituteInPlace \
          pkg/minikube/registry/drvs/qemu2/qemu2.go \
          --replace "/usr/local/opt/qemu/share/qemu" "${qemu}/share/qemu" \
          --replace "/opt/homebrew/opt/qemu/share/qemu" "${qemu}/share/qemu"
      ''
    ) + (
      lib.optionalString (withQemu && stdenv.isLinux) ''
        substituteInPlace \
          pkg/minikube/registry/drvs/qemu2/qemu2.go \
          --replace "/usr/share/OVMF/OVMF_CODE.fd" "${OVMF.firmware}" \
          --replace "/usr/share/AAVMF/AAVMF_CODE.fd" "${OVMF.firmware}"
      ''
    );

  nativeBuildInputs = [ installShellFiles pkg-config which makeWrapper ];

  buildInputs = if stdenv.isDarwin then [ vmnet ] else if stdenv.isLinux then [ libvirt ] else null;

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
    description = "A tool that makes it easy to run Kubernetes locally";
    mainProgram = "minikube";
    license = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester atkinschang Chili-Man ];
  };
}
