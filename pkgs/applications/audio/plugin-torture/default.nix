{ lib, stdenv, fetchFromGitHub, boost, ladspaH, lilv, lv2, pkg-config, serd, sord, sratom }:

stdenv.mkDerivation {
  pname = "plugin-torture";
  version = "2016-07-25";

  src = fetchFromGitHub {
    owner = "cth103";
    repo = "plugin-torture";
    rev = "8b9c43197dca372da6b9c8212224ec86b5f16b4a";
    sha256 = "1xyhvhm85d9z0kw716cjllrrzksn4s4bw34layg8hf4m5m31sp2p";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ boost ladspaH lilv lv2 serd sord sratom ];

  installPhase = ''
    mkdir -p $out/bin
    cp plugin-torture $out/bin/
    cp find-safe-plugins $out/bin/
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://github.com/cth103/plugin-torture";
    description = "A tool to test LADSPA and LV2 plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
