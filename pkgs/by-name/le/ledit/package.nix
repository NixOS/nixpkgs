{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
}:

stdenv.mkDerivation {
  pname = "ledit";
  version = "2.06";

  src = fetchFromGitHub {
    owner = "chetmurthy";
    repo = "ledit";
    rev = "3dbd668d9c69aab5ccd61f6b906c14122ae3271d";
    hash = "sha256-9+isvwOw5Iw5OToztqZ5PiQPj6Pxl2ZqAC7UMF+tCM4=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /bin/rm rm --replace /usr/local/ $out/
  '';

  strictDeps = true;

  dontStrip = true;

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    camlp5
  ];

  buildInputs = with ocamlPackages; [
    camlp5
    camlp-streams
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    echo hello | $out/bin/ledit -h /dev/null cat > ledit-check.out
    grep -q hello ledit-check.out
    runHook postInstallCheck
  '';

  meta = {
    homepage = "http://pauillac.inria.fr/~ddr/ledit/";
    description = "Line editor, allowing to use shell commands with control characters like in emacs";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.delta ];
    mainProgram = "ledit";
  };
}
