{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
  gnupg,
  openssh,
  buildPackages,
  nix-update-script,
  versionCheckHook,
  mkdocs,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jujutsu";
  version = "0.40.0";
  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PBrsNHywOUEiFyyHW6J4WHDmLwVWv2JkbHCNvbE0tHE=";
  };

  cargoHash = "sha256-jOklgYw6mYCs/FnTczmkT7MlepNtnHXfFB4lghpLOVE=";

  nativeBuildInputs = [
    installShellFiles
    mkdocs
    python3.pkgs.mdx-breakless-lists
    python3.pkgs.mdx-truly-sane-lists
    python3.pkgs.mike
    python3.pkgs.mkdocs-include-markdown-plugin
    python3.pkgs.mkdocs-material
    python3.pkgs.mkdocs-redirects
    python3.pkgs.mkdocs-table-reader-plugin
  ];

  nativeCheckInputs = [
    gitMinimal
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

  preBuild = ''
    mkdocs build -d $name
  '';

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
    ''
    + ''
      mkdir -p $doc/share/doc
      mv $name $doc/share/doc
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/jj";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Git-compatible DVCS that is both simple and powerful";
    homepage = "https://jj-vcs.dev/";
    changelog = "https://github.com/jj-vcs/jj/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _0x4A6F
      thoughtpolice
      emily
      bbigras
    ];
    mainProgram = "jj";
  };
})
