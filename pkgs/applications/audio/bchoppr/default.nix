{ stdenv, fetchFromGitHub, pkg-config, cairo, libX11, lv2 }:

stdenv.mkDerivation rec {
  pname = "bchoppr";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "1nd6byy75f0rbz9dm9drhxmpsfhxhg0y7q3v2m3098llynhy9k2j";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo libX11 lv2 ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/sjaehn/BChoppr;
    description = "An audio stream chopping LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
