{ lib, stdenv, fetchFromGitHub, pkg-config, cairo, libX11, lv2 }:

stdenv.mkDerivation rec {
  pname = "bchoppr";
  version = "1.10.6";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "sha256-iCDAIV2p1OkZxOMo8A6zBrOGd49FXAGqLZWk0Kbvgec=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo libX11 lv2 ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BChoppr";
    description = "An audio stream chopping LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
