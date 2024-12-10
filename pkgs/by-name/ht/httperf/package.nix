{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl }:

stdenv.mkDerivation rec {
  pname = "httperf";
  version = "0.9.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = pname;
    rev = "3209c7f9b15069d4b79079e03bafba5b444569ff";
    sha256 = "0p48z9bcpdjq3nsarl26f0xbxmqgw42k5qmfy8wv5bcrz6b3na42";
  };

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ openssl ];

  configurePhase = ''
    autoreconf -i
    mkdir -pv build
    cd build
    ../configure
  '';

  installPhase = ''
    mkdir -vp $out/bin
    mv -v src/httperf $out/bin
  '';

  meta = with lib; {
    description = "Httperf HTTP load generator";
    homepage = "https://github.com/httperf/httperf";
    maintainers = [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    mainProgram = "httperf";
  };

}
