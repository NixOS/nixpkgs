{ stdenv, fetchFromGitHub, xorg, xorgproto, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "GxPlugins.lv2";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = pname;
    rev = "v${version}";
    sha256 = "16r5bj7w726d9327flg530fn0bli4crkxjss7i56yhb1bsi39mbv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 xorgproto cairo lv2
  ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/brummer10/GxPlugins.lv2;
    description = "A set of extra lv2 plugins from the guitarix project";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3;
  };
}
