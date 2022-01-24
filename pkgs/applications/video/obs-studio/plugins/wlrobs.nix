{ lib, stdenv, fetchhg
, meson, pkg-config, ninja
, wayland, obs-studio, libX11
}:

stdenv.mkDerivation {
  pname = "wlrobs";
  version = "unstable-2021-05-13";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wlrobs";
    rev = "4184a4a8ea7dc054c993efa16007f3a75b2c6f51";
    sha256 = "146xirzd3nw1sd216y406v1riky9k08b6a0j4kwxrif5zyqa3adc";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ wayland obs-studio libX11 ];

  meta = with lib; {
    description = "An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ grahamc V ];
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
