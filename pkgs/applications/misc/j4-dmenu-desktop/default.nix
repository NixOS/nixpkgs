{ stdenv, fetchFromGitHub, cmake, dmenu }:

stdenv.mkDerivation rec {
  name    = "j4-dmenu-desktop-${version}";
  version = "2.14";

  src = fetchFromGitHub {
    owner  = "enkore";
    repo   = "j4-dmenu-desktop";
    rev    = "r${version}";
    sha256 = "14srrkz4qx8qplgrrjv38ri4pnkxaxaq6jy89j13xhna492bq128";
  };

  postPatch = ''
    sed -e 's,dmenu -i,${dmenu}/bin/dmenu -i,g' -i ./src/Main.hh
  '';

  nativeBuildInputs = [ cmake ];

  # tests are fetching an external git repository
  cmakeFlags = [ "-DNO_TESTS:BOOL=ON" ];

  meta = with stdenv.lib; {
    description = "A wrapper for dmenu that recognize .desktop files";
    homepage    = "https://github.com/enkore/j4-dmenu-desktop";
    license     = licenses.gpl3;
    maintainer  = with maintainers; [ ericsagnes ];
  };
}
