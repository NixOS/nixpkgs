{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, rofi, gtk3 }:

stdenv.mkDerivation rec {
  pname = "rofi-file-browser-extended";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "marvinkreis";
    repo = pname;
    rev = version;
    sha256 = "1grcal8ga4gpaj3p1dvx4zmqai93jjz2izpj91lxwj0dbz1gmbdm";
    fetchSubmodules = true;
  };

  prePatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace ' ''${ROFI_PLUGINS_DIR}' " $out/lib/rofi" \
      --replace "/usr/share/" "$out/share/"
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ rofi gtk3 ];

  ROFI_PLUGINS_DIR = "$out/lib/rofi";

  dontUseCmakeBuildDir = true;

  meta = with lib; {
    description = "Use rofi to quickly open files";
    homepage = "https://github.com/marvinkreis/rofi-file-browser-extended";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
