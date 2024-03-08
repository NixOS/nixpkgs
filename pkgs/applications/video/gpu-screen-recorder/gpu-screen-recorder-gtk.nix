{ stdenv
, lib
, fetchurl
, pkg-config
, makeWrapper
, gtk3
, libpulseaudio
, libdrm
, gpu-screen-recorder
, libglvnd
, wrapGAppsHook
}:

stdenv.mkDerivation {
  pname = "gpu-screen-recorder-gtk";
  version = "3.2.5";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder-gtk.git.r175.cfd18af.tar.gz";
    hash = "sha256-HhZe22Hm9yGoy5WoyuP2+Wj8E3nMs4uf96mzmP6CMqU=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook
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

  meta = with lib; {
    description = "GTK frontend for gpu-screen-recorder.";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
