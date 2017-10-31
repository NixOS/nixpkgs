{ stdenv, fetchhg, pidgin, cmake, libxml2 } :

let
  version = "40ddb6d";
in
stdenv.mkDerivation rec {
  name = "purple-vk-plugin-${version}";

  src = fetchhg {
    url = "https://bitbucket.org/olegoandreev/purple-vk-plugin";
    rev = "${version}";
    sha256 = "02p57fgx8ml00cbrb4f280ak2802svz80836dzk9f1zwm1bcr2qc";
  };

  buildInputs = [ pidgin cmake libxml2 ];

  preConfigure = ''
    sed -i -e 's|DESTINATION.*PURPLE_PLUGIN_DIR}|DESTINATION lib/purple-2|' CMakeLists.txt
  '';

  cmakeFlags = "-DCMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT=1";

  meta = {
    homepage = https://bitbucket.org/olegoandreev/purple-vk-plugin;
    description = "Vk (russian social network) plugin for Pidgin / libpurple";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
