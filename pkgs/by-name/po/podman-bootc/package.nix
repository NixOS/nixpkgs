{
  lib,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  libisoburn,
  libvirt,
  pkg-config,
  stdenv,
}:

buildGoModule rec {
  pname = "podman-bootc";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    tag = "v${version}";
    hash = "sha256-Hxg2QSedPAWYZpuesUEFol9bpTppjB0/MpCcB+txMDc=";
  };

  patches = [ ./respect-home-env.patch ];

  vendorHash = "sha256-8QP4NziLwEo0M4NW5UgSEMAVgBDxmnE+PLbpyclK9RQ=";

  tags = [
    "exclude_graphdriver_btrfs"
    "btrfs_noversion"
    "exclude_graphdriver_devicemapper"
    "containers_image_openpgp"
    "remote"
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    libvirt
    libisoburn
  ];

  # All tests depend on booting virtual machines, which is infeasible here.
  doCheck = false;

  postInstall =
    let
      podman-bootc = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/podman-bootc";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      # podman-bootc always tries to touch cache and run dirs, no matter the command
      export HOME=$TMPDIR
      export XDG_RUNTIME_DIR=$TMPDIR

      installShellCompletion --cmd podman-bootc \
        --bash <(${podman-bootc} completion bash) \
        --fish <(${podman-bootc} completion fish) \
        --zsh <(${podman-bootc} completion zsh)
    '';

  meta = {
    description = "Streamlining podman+bootc interactions";
    homepage = "https://github.com/containers/podman-bootc";
    changelog = "https://github.com/containers/podman-bootc/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ evan-goode ];
    license = lib.licenses.asl20;
    # x86_64-darwin does not seem to be supported at this time:
    # https://github.com/containers/podman-bootc/issues/46
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "podman-bootc";
  };
}
