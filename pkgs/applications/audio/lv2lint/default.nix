{ stdenv, lib, fetchurl, pkg-config, meson, ninja, lv2, lilv, curl, libelf }:

stdenv.mkDerivation rec {
  pname = "lv2lint";
  version = "0.16.2";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}/snapshot/${pname}-${version}.tar.xz";
    sha256 = "sha256-sjgQVx8uGNPWcUwKzGUhChpfzXj/8D8cggVTpcHEXPQ=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ lv2 lilv curl libelf ];

  meta = with lib; {
    description = "Check whether a given LV2 plugin is up to the specification";
    homepage = "https://open-music-kontrollers.ch/lv2/${pname}:";
    license = licenses.artistic2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
  };
}
