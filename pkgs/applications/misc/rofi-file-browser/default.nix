{ stdenv, fetchFromGitHub, cmake, pkgconfig, rofi, gtk3 }:

stdenv.mkDerivation rec {
  pname = "rofi-file-browser-extended";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "marvinkreis";
    repo = pname;
    rev = version;
    sha256 = "10wk5sif3bmvsgyk2gdy0qhpv1b37zgzf89n3h0yh7pg195fi2gn";
    fetchSubmodules = true;
  };

  prePatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace ' ''${ROFI_PLUGINS_DIR}' " $out/lib/rofi" \
      --replace "/usr/share/" "$out/share/"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ rofi gtk3 ];

  ROFI_PLUGINS_DIR = "$out/lib/rofi";

  dontUseCmakeBuildDir = true;

  meta = with stdenv.lib; {
    description = "Use rofi to quickly open files";
    homepage = "https://github.com/marvinkreis/rofi-file-browser-extended";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
