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
  version = "0.3.5-alpha";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber";
    rev = version;
    hash = "sha256-wf0JNWNliDGNvlbWoatPqDKmVaBzHeCKOvJWuE9PnpQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OhrSK+bvdQP1bAcEbS2foHxY4BEYoJ9SQaE7Rj9od0Y=";

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
      diff -U3 --color=auto <(amber -e 'echo "Hello, World"') <(echo 'Hello, World')
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
