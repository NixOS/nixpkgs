{ stdenv, fetchFromGitHub, cmake, dmenu }:

stdenv.mkDerivation rec {
  pname = "j4-dmenu-desktop";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "enkore";
    repo = pname;
    rev = "r${version}";
    sha256 = "0v23fimkn83dcm5p53y2ymhklff3kwppxhf75sm8xmswrzkixpgc";
  };

  postPatch = ''
    sed -e 's,dmenu -i,${dmenu}/bin/dmenu -i,g' -i ./src/Main.hh
  '';

  nativeBuildInputs = [ cmake ];

  # tests are fetching an external git repository
  cmakeFlags = [
    "-DWITH_TESTS=OFF"
    "-DWITH_GIT_CATCH=OFF"
  ];

  meta = with stdenv.lib; {
    description = "A wrapper for dmenu that recognize .desktop files";
    homepage = "https://github.com/enkore/j4-dmenu-desktop";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.unix;
  };
}
