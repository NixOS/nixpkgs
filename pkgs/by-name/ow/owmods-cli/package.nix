{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  installShellFiles,
  zstd,
  libsoup_3,
  makeWrapper,
  mono,
  wrapWithMono ? true,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "owmods-cli";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "ow-mods";
    repo = "ow-mod-man";
    rev = "cli_v${version}";
    hash = "sha256-NIg8heytWUshpoUbaH+RFIvwPBQGXL6yaGKvUuGnxg8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kLuiNfrxc3Z8UeDQ2Mb6N78TST6c2f4N7mt4X0zv1Zk=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ]
  ++ lib.optional wrapWithMono makeWrapper;

  buildInputs = [
    zstd
    libsoup_3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildAndTestSubdir = "owmods_cli";

  postInstall = ''
    cargo xtask dist_cli
    installManPage dist/cli/man/*
    installShellCompletion --cmd owmods \
    dist/cli/completions/owmods.{bash,fish,zsh}
  ''
  + lib.optionalString wrapWithMono ''
    wrapProgram $out/bin/${meta.mainProgram} --prefix PATH : '${mono}/bin'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_cli";
    downloadPage = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${version}";
    changelog = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${version}";
    mainProgram = "owmods";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bwc9876
      spoonbaker
      locochoco
    ];
  };
}
