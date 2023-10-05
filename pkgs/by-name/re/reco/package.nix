{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, wrapGAppsHook
, libgee
, pantheon
, gst_all_1
, libpulseaudio
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reco";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "reco";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-tRb43SCDTeEfLIQz3tpzN7Kh4EXmntZ9C+z2yn+4fiY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    libgee
    pantheon.granite7
    libpulseaudio
    gst_all_1.gstreamer
  ];

  meta = with lib; {
    homepage = "https://github.com/ryonakano/reco";
    description = "An audio recorder focused on recording";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ twkstar ];
    platforms = platforms.linux;
  };
})
