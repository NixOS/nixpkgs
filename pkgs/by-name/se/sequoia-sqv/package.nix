{ lib
, fetchFromGitLab
, nettle
, nix-update-script
, rustPlatform
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-sqv";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sqv";
    rev = "v${version}";
    hash = "sha256-frGukJDsxq+BWLPC/4imfc42lDKVF8BPIQQDazaLaQ0=";
  };

  cargoHash = "sha256-1h1nXtXMTwL8ICxWTV8My0IdE+6w0L7xXZD012Cv5U8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    nettle
  ];
  # Install shell completion files and manual pages. Unfortunatly it is hard to
  # predict the paths to all of these files generated during the build, and it
  # is impossible to control these using `$OUT_DIR` or alike, as implied by
  # upstream's `build.rs`. This is a general Rust issue also discussed in
  # https://github.com/rust-lang/cargo/issues/9661, also discussed upstream at:
  # https://gitlab.com/sequoia-pgp/sequoia-wot/-/issues/56
  postInstall = ''
    installManPage target/*/release/build/*/out/man-pages/sqv.1
    installShellCompletion --cmd sqv \
      --zsh target/*/release/build/*/out/shell-completions/_sqv \
      --bash target/*/release/build/*/out/shell-completions/sqv.bash \
      --fish target/*/release/build/*/out/shell-completions/sqv.fish
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line OpenPGP signature verification tool";
    homepage = "https://docs.sequoia-pgp.org/sqv/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "sqv";
  };
}
