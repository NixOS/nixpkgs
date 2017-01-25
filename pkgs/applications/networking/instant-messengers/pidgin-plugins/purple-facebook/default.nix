{ stdenv, fetchFromGitHub, pidgin, glib, json_glib, mercurial, autoreconfHook } :

stdenv.mkDerivation rec {
  name = "purple-facebook-${version}";
  version = "2016-04-09";

  src = fetchFromGitHub {
    owner = "dequis";
    repo = "purple-facebook";
    rev = "66ee77378d82";
    sha256 = "0kr9idl79h70lacd3cvpmzvfd6il3b5xm2fj1sj96l7bjhiw9s3y";
  };

  preAutoreconf = "./autogen.sh";

  makeFlags = [
    "PLUGIN_DIR_PURPLE=/lib/pidgin/"
    "DATA_ROOT_DIR_PURPLE=/share"
    "DESTDIR=$(out)"
  ];

  postInstall =  ''
    mkdir -p $out/lib/purple-2
    cp pidgin/libpurple/protocols/facebook/.libs/*.so $out/lib/purple-2/
  '';

  buildInputs = [ pidgin glib json_glib mercurial autoreconfHook];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Facebook protocol plugin for libpurple";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davorb ];
  };
}
