{ lib, stdenv
, desktop-file-utils
, fetchFromGitHub
, fftwFloat
, glib
, glibmm
, gtk4
, gtkmm4
, itstool
, libbs2b
, libebur128
, libsamplerate
, libsndfile
, lilv
, lv2
, meson
, ninja
, nlohmann_json
, pipewire
, pkg-config
, python3
, rnnoise
, rubberband
, speexdsp
, wrapGAppsHook
, zita-convolver
}:

stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "v${version}";
    hash = "sha256:1m3jamnhgpx3z51nfc8xg7adhf5x7dirvw0wf129hzxx4fjl7rch";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    fftwFloat
    glib
    glibmm
    gtk4
    gtkmm4
    libbs2b
    libebur128
    libsamplerate
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    rnnoise
    rubberband
    speexdsp
    zita-convolver
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  separateDebugInfo = true;

  meta = with lib; {
    description = "Audio effects for PipeWire applications.";
    homepage = "https://github.com/wwmm/easyeffects";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
