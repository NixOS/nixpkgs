{ stdenv, fetchgit, pkgconfig, pidgin, json-glib, glib, http-parser, sqlite, olm, libgcrypt } :

let
  version = "2018-08-03";
in
stdenv.mkDerivation rec {
  pname = "purple-matrix-unstable";
  inherit version;

  src = fetchgit {
    url = "https://github.com/matrix-org/purple-matrix";
    rev = "5a7166a3f54f85793c6b60662f8d12196aeaaeb0";
    sha256 = "0ph0s24b37d1c50p8zbzgf4q2xns43a8v6vk85iz633wdd72zsa0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json-glib glib http-parser sqlite olm libgcrypt ];

  hardeningDisable = [ "fortify" ]; # upstream compiles with -O0

  makeFlags = [
    "PLUGIN_DIR_PURPLE=${placeholder "out"}/lib/purple-2"
    "DATA_ROOT_DIR_PURPLE=${placeholder "out"}/share"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matrix-org/purple-matrix;
    description = "Matrix support for Pidgin / libpurple";
    license = licenses.gpl2;
    maintainers = with maintainers; [ symphorien ];
  };
}
