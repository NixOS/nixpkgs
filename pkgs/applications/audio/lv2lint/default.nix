{ stdenv, lib, fetchurl, pkg-config, meson, ninja, lv2, lilv, curl, libelf }:

stdenv.mkDerivation rec {
  pname = "lv2lint";
  version = "0.12.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}/snapshot/${pname}-${version}.tar.xz";
    sha256 = "19q9cg4qxgpajf75kpqk4acxk2nqqwaacqf9cschi1f3mdadsvsp";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ lv2 lilv curl libelf ];

  meta = with lib; {
    homepage    = "https://open-music-kontrollers.ch/lv2/${pname}:";
    license     = licenses.artistic2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
  };
}
