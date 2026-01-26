{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  python3,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "kbs2";
    rev = "v${version}";
    hash = "sha256-X+NhUQzxfok9amqAiim/vjkee45hjdPedsZc3zwcOXA=";
  };

  cargoHash = "sha256-Auk/6ltjfXE1VzlxmKikcV6MHDczpuRqKJrg6UGgJZE=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.hostPlatform.isLinux [ python3 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlags = [
    "--skip=kbs2::config::tests::test_find_config_dir"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--skip=test_ragelib_rewrap_keyfile" ];

  postInstall = ''
    mkdir -p $out/share/kbs2
    cp -r contrib/ $out/share/kbs2
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kbs2 \
      --bash <($out/bin/kbs2 --completions bash) \
      --fish <($out/bin/kbs2 --completions fish) \
      --zsh <($out/bin/kbs2 --completions zsh)
  '';

  meta = {
    description = "Secret manager backed by age";
    mainProgram = "kbs2";
    homepage = "https://github.com/woodruffw/kbs2";
    changelog = "https://github.com/woodruffw/kbs2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
