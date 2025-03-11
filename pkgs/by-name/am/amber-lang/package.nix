{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bc,
  util-linux,
  makeWrapper,
  runCommand,
  amber-lang,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "amber-lang";
  version = "0.4.0-alpha";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber";
    rev = version;
    hash = "sha256-N9G/2G8+vrpr1/K7XLwgW+X2oAyAaz4qvN+EbLOCU1Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-e5+L7Qgd6hyqT1Pb9X7bVtRr+xm428Z5J4hhsYNnGtU=";

  preConfigure = ''
    substituteInPlace src/compiler.rs \
      --replace-fail 'Command::new("/usr/bin/env")' 'Command::new("env")'
  '';

  nativeBuildInputs = [ makeWrapper ];

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
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.run = runCommand "amber-lang-eval-test" { nativeBuildInputs = [ amber-lang ]; } ''
      diff -U3 --color=auto <(amber eval 'echo "Hello, World"') <(echo 'Hello, World')
      touch $out
    '';
  };

  meta = with lib; {
    description = "Programming language compiled to bash";
    homepage = "https://amber-lang.com";
    license = licenses.gpl3Plus;
    mainProgram = "amber";
    maintainers = with maintainers; [
      cafkafk
      uncenter
      aleksana
    ];
    platforms = platforms.unix;
  };
}
