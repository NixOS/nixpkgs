{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation {
  pname = "httperf";
  version = "0.9.1";

  src = fetchFromGitHub {
    repo = "httperf";
    owner = "httperf";
    rev = "3209c7f9b15069d4b79079e03bafba5b444569ff";
    sha256 = "0p48z9bcpdjq3nsarl26f0xbxmqgw42k5qmfy8wv5bcrz6b3na42";
  };

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ openssl ];

  configurePhase = ''
    runHook preConfigure

    autoreconf -i
    mkdir -pv build
    cd build
    ../configure

    runHook postConfigure
  '';

  installPhase = ''
    mkdir -vp $out/bin
    mv -v src/httperf $out/bin
  '';

  meta = {
    description = "HTTP load generator";
    homepage = "https://github.com/httperf/httperf";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "httperf";
  };

}
