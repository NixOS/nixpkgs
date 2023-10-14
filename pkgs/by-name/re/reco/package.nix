{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, pantheon
, gst_all_1
, libgee
, libpulseaudio
, wrapGAppsHook
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
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    libgee
    gst_all_1.gstreamer
    pantheon.granite7
    libpulseaudio
  ];

  postInstall = ''
    mv $out/bin/com.github.ryonakano.reco $out/bin/reco
    substituteInPlace $out/share/applications/com.github.ryonakano.reco.desktop \
      --replace 'Exec=com.github.ryonakano.reco' 'Exec=${placeholder "out"}/bin/reco'
  '';

  meta = with lib; {
    homepage = "https://github.com/ryonakano/reco";
    description = "An audio recorder focused on recording";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ stfr ];
    platforms = platforms.linux;
  };
})
