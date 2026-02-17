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

buildGoModule (finalAttrs: {
  pname = "minikube";
  version = "1.38.0";

  vendorHash = "sha256-Sm/c5NhoLyd7+GFpOw6wyZNqEnJyREHgZf33U7g1LuE=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6kBygQ9agBcFJZxoiGb4KsPMz/jnZU54sGMWjF3mTuA=";
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
    make COMMIT=${finalAttrs.src.rev}
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

  meta = {
    homepage = "https://minikube.sigs.k8s.io";
    description = "Tool that makes it easy to run Kubernetes locally";
    mainProgram = "minikube";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      vdemeester
      atkinschang
      Chili-Man
    ];
  };
})
