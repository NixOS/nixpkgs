{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  which,
  libvirt,
  withQemu ? false,
  qemu,
  makeWrapper,
  OVMF,
}:

buildGoModule rec {
  pname = "minikube";
  version = "1.37.0";

  vendorHash = "sha256-xPTJMxKnEwZKKCc6QZxeL+03qM0oldOIKY4sPjSw3Ak=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-qyeGBL952YIloB/69W+QWosXxwIrazE0OMdVO6LshPk=";
  };
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "export GOTOOLCHAIN := go\$(GO_VERSION)" "export GOTOOLCHAIN := local"
  ''
  + (lib.optionalString (withQemu && stdenv.hostPlatform.isDarwin) ''
    substituteInPlace \
      pkg/minikube/registry/drvs/qemu2/qemu2.go \
      --replace "/usr/local/opt/qemu/share/qemu" "${qemu}/share/qemu" \
      --replace "/opt/homebrew/opt/qemu/share/qemu" "${qemu}/share/qemu"
  '')
  + (lib.optionalString (withQemu && stdenv.hostPlatform.isLinux) ''
    substituteInPlace \
      pkg/minikube/registry/drvs/qemu2/qemu2.go \
      --replace "/usr/share/OVMF/OVMF_CODE.fd" "${OVMF.firmware}" \
      --replace "/usr/share/AAVMF/AAVMF_CODE.fd" "${OVMF.firmware}"
  '');

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    which
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libvirt ];

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
    maintainers = with maintainers; [
      ebzzry
      vdemeester
      atkinschang
      Chili-Man
    ];
  };
}
