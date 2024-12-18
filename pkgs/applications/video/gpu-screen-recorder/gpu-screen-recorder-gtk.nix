{ stdenv
, lib
, fetchgit
, pkg-config
, makeWrapper
, gtk3
, libpulseaudio
, libdrm
, gpu-screen-recorder
, libglvnd
, wrapGAppsHook3
}:

stdenv.mkDerivation {
  pname = "gpu-screen-recorder-gtk";
  version = "3.7.6";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-gtk";
    rev = "cd777c1506e20514df4b97345e480051cbaf9693";
    hash = "sha256-ZBYYsW75tq8TaZp0F4v7YIHKHk/DFBIGy3X781ho2oE=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libpulseaudio
    libdrm
  ];

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    install -Dt $out/bin/ gpu-screen-recorder-gtk
    install -Dt $out/share/applications/ gpu-screen-recorder-gtk.desktop

    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gpu-screen-recorder ]})
    # we also append /run/opengl-driver/lib as it otherwise fails to find libcuda.
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]}:/run/opengl-driver/lib)
  '';

  meta = {
    description = "GTK frontend for gpu-screen-recorder.";
    mainProgram = "gpu-screen-recorder-gtk";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
