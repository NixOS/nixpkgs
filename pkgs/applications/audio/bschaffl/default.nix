{ lib, stdenv, fetchFromGitHub, pkg-config, cairo, libX11, lv2 }:

stdenv.mkDerivation rec {
  pname = "bschaffl";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "sha256-R6QTADPE2PW/ySQla2lQbb308jrHXZ43DpFxUfQ0/NY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo libX11 lv2 ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BSchaffl";
    description = "Pattern-controlled MIDI amp & time stretch LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
