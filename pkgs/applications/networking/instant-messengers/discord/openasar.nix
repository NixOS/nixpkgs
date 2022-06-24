{ lib, stdenv, fetchFromGitHub, nodejs, bash, nodePackages }:

stdenv.mkDerivation rec {
  version = "unstable-2022-06-10";
  pname = "openasar";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "c6f2f5eb7827fea14cb4c54345af8ff6858c633a";
    sha256 = "m6e/WKGgkR8vjKcHSNdWE25MmDQM1Z3kgB24OJgbw/w=";
  };

  buildPhase = ''
    runHook preBuild

    bash scripts/injectPolyfills.sh
    substituteInPlace src/index.js --replace 'nightly' '${version}'
    ${nodejs}/bin/node scripts/strip.js
    ${nodePackages.asar}/bin/asar pack src app.asar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install app.asar $out

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "Open-source alternative of Discord desktop's \"app.asar\".";
    homepage = "https://openasar.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ pedrohlc ];
    platforms = nodejs.meta.platforms;
  };
}
