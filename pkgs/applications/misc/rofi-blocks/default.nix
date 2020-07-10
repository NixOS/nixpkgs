{ stdenv, fetchFromGitHub, rofi-unwrapped, pkg-config, autoreconfHook, json-glib, cairo }:

stdenv.mkDerivation rec {
  pname = "rofi-blocks";
  version = "2020-07-09";

  src = fetchFromGitHub {
    owner = "OmarCastro";
    repo = pname;
    rev = "f219ceedd1c7baab6de92a69e94ee68bcad8f2bc";
    sha256 = "1mn2dq30zm7ilsyjcxbbr3l999zisdyfg5z6k7j5z9wa8zbcss0l";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook json-glib cairo ];

  buildInputs = [ rofi-unwrapped ];

  enableParallelBuilding = true;

  patches = [
    ./0001-Patch-plugindir-to-output.patch
  ];

  meta = with stdenv.lib; {
    description = "Rofi modi that allows controlling rofi content throug communication with an external program.";
    homepage = "https://github.com/OmarCastro/rofi-blocks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ oro ];
  };
}
