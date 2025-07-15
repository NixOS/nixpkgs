{
  stdenv,
  mlton,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "initool";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "initool";
    rev = "v${version}";
    hash = "sha256-PROsyYw8xdnn0PX+3OyUPaybQbTmO88G2koeZhBfwjg=";
  };

  nativeBuildInputs = [ mlton ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp initool $out/bin/

    runHook postInstall
  '';

  meta = {
    inherit (mlton.meta) platforms;

    description = "Manipulate INI files from the command line";
    mainProgram = "initool";
    homepage = "https://github.com/dbohdan/initool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ e1mo ];
    changelog = "https://github.com/dbohdan/initool/releases/tag/v${version}";
  };
}
