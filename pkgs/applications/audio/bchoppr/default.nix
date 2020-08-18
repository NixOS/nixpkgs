{ stdenv, fetchFromGitHub, pkg-config, cairo, libX11, lv2 }:

stdenv.mkDerivation rec {
  pname = "bchoppr";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "${version}";
    sha256 = "16b0sg7q2b8l4y4bp5s3yzsj9j6jayjy2mlvqkby6l7hcgjcj493";
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
