{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bc,
  util-linux,
  gnused,
  makeWrapper,
  installShellFiles,
  stdenv,
  runCommand,
  amber-lang,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "amber-lang";
  version = "0.5.1-alpha";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber";
    tag = version;
    hash = "sha256-v1uJe3vVGKXaZcQzdoYzu/bJKMQnS4IYET4QLPW+J8Y=";
  };

  patches = [
    # Upstreamed in #995, can be removed in >= 0.5.2
    # github.com/amber-lang/amber/pull/995
    ./fix_word_boundaries.patch
  ];

  cargoHash = "sha256-aXcxlmmDYLFbyRJYyGE1gbQMbdysHx4iWXsrUj10Eco=";

  preConfigure = ''
    substituteInPlace src/compiler.rs \
      --replace-fail 'Command::new("/usr/bin/env")' 'Command::new("env")'
  '';

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeCheckInputs = [
    bc
    # 'rev' in generated bash script of test
    # tests::validity::variable_ref_function_invocation
    util-linux
  ];

  checkFlags = [
    "--skip=tests::extra::download"
    "--skip=tests::formatter::all_exist"
  ];

  postInstall = ''
    wrapProgram "$out/bin/amber" --prefix PATH : "${lib.makeBinPath [ bc ]}"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd amber \
      --bash <($out/bin/amber completion)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.run = runCommand "amber-lang-eval-test" { nativeBuildInputs = [ amber-lang ]; } ''
      diff -U3 --color=auto <(amber eval 'echo "Hello, World"') <(echo 'Hello, World')
      touch $out
    '';
  };

  meta = {
    description = "Programming language compiled to bash";
    homepage = "https://amber-lang.com";
    license = lib.licenses.gpl3Plus;
    mainProgram = "amber";
    maintainers = with lib.maintainers; [
      cafkafk
      aleksana
    ];
    platforms = lib.platforms.unix;
  };
}
