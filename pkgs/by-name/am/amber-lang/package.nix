{ lib,
  fetchFromGitHub,
  rustPlatform,
  bc,
  makeWrapper,
  runCommand,
  amber-lang
}:

rustPlatform.buildRustPackage rec {
  pname = "amber-lang";
  version = "0.3.1-alpha";

  src = fetchFromGitHub {
    owner = "Ph0enixKM";
    repo = "Amber";
    rev = version;
    hash = "sha256-VSlLPgoi+KPnUQJEb6m0VZQVs1zkxEnfqs3fAp8m1o4=";
  };

  cargoHash = "sha256-NzcyX/1yeFcI80pNxx/OTkaI82qyQFJW8U0vPbqSU7g=";

  buildInputs = [ makeWrapper ];

  nativeCheckInputs = [ bc ];

  preConfigure = ''
    substituteInPlace src/compiler.rs \
      --replace-fail "/bin/bash" "bash"
  '';

  postInstall = ''
    wrapProgram "$out/bin/amber" --prefix PATH : "${lib.makeBinPath [bc]}"
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
    maintainers = with maintainers; [ cafkafk uncenter ];
    platforms = platforms.unix;
  };
}
