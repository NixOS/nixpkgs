{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bc,
  util-linux,
  makeWrapper,
  runCommand,
  amber-lang,
}:

rustPlatform.buildRustPackage rec {
  pname = "amber-lang";
  version = "0.3.3-alpha";

  src = fetchFromGitHub {
    owner = "Ph0enixKM";
    repo = "Amber";
    rev = version;
    hash = "sha256-Al1zTwQufuVGSlttf02s5uI3cyCNDShhzMT3l9Ctv3Y=";
  };

  cargoHash = "sha256-HbkIkCVy2YI+nP5t01frXBhlp/rCsB6DwLL53AHJ4vE=";

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

  postInstall = ''
    wrapProgram "$out/bin/amber" --prefix PATH : "${lib.makeBinPath [ bc ]}"
  '';

  passthru.tests.run = runCommand "amber-lang-eval-test" { nativeBuildInputs = [ amber-lang ]; } ''
    diff -U3 --color=auto <(amber -e 'echo "Hello, World"') <(echo 'Hello, World')
    touch $out
  '';

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
