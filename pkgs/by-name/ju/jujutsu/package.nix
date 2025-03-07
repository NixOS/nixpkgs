{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  zstd,
  libgit2,
  libssh2,
  openssl,
  git,
  gnupg,
  openssh,
  buildPackages,
  nix-update-script,
  testers,
  jujutsu,
}:

let
  version = "0.27.0";
in

rustPlatform.buildRustPackage {
  pname = "jujutsu";
  inherit version;

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-fBgJrSglH46+NHu3spk5mC51ASDHWnOoW6veKZ0R2YA=";
  };

  useFetchCargoVendor = true;

  cargoPatches = [
    # <https://github.com/jj-vcs/jj/pull/5315>
    ./libgit2-1.9.0.patch
  ];

  cargoHash = "sha256-35DJdAUXc2gb/EXECScwinSzzp7uaxFbUxedjqRGfj8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    zstd
    libgit2
    libssh2
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  nativeCheckInputs = [
    git
    gnupg
    openssh
  ];

  cargoBuildFlags = [
    # Don’t install the `gen-protos` build tool.
    "--bin"
    "jj"
  ];

  useNextest = true;

  cargoTestFlags = [
    # Don’t build the `gen-protos` build tool when running tests.
    "-p"
    "jj-lib"
    "-p"
    "jj-cli"
  ];

  env = {
    # Disable vendored libraries.
    ZSTD_SYS_USE_PKG_CONFIG = "1";
    LIBGIT2_NO_VENDOR = "1";
    LIBSSH2_SYS_USE_PKG_CONFIG = "1";
  };

  postInstall =
    let
      jj = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/jj";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      mkdir -p $out/share/man
      ${jj} util install-man-pages $out/share/man/

      installShellCompletion --cmd jj \
        --bash <(COMPLETE=bash ${jj}) \
        --fish <(COMPLETE=fish ${jj}) \
        --zsh <(COMPLETE=zsh ${jj})
    '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = jujutsu;
        command = "jj --version";
      };
    };
  };

  meta = {
    description = "Git-compatible DVCS that is both simple and powerful";
    homepage = "https://github.com/jj-vcs/jj";
    changelog = "https://github.com/jj-vcs/jj/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _0x4A6F
      thoughtpolice
      emily
      bbigras
    ];
    mainProgram = "jj";
  };
}
