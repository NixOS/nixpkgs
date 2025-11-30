{
  lib,
  fetchFromGitHub,
  stdenv,
  ffmpeg,
  frei0r,
  sox,
  gtk3,
  python3,
  ladspaPlugins,
  gobject-introspection,
  makeWrapper,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "flowblade";
  version = "2.22.1.1";

  src = fetchFromGitHub {
    owner = "jliljebl";
    repo = "flowblade";
    rev = "v${version}";
    sha256 = "sha256-I9sh3FCN8zr5TF449rv/Xs8+Sb1xNWBmFcB7aKW3jVQ=";
  };

  buildInputs = [
    ffmpeg
    frei0r
    sox
    gtk3
    ladspaPlugins
    (python3.withPackages (
      ps: with ps; [
        mlt
        pygobject3
        dbus-python
        numpy
        pillow
        libusb1
      ]
    ))
  ];

  nativeBuildInputs = [
    gobject-introspection
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a ${src}/flowblade-trunk $out/flowblade

    makeWrapper $out/flowblade/flowblade $out/bin/flowblade \
      --set FREI0R_PATH ${frei0r}/lib/frei0r-1 \
      --set LADSPA_PATH ${ladspaPlugins}/lib/ladspa \
      --set GDK_BACKEND x11 \
      --set SDL_VIDEODRIVER x11 \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
      ''${gappsWrapperArgs[@]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multitrack Non-Linear Video Editor";
    homepage = "https://jliljebl.github.io/flowblade/";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ polygon ];
    mainProgram = "flowblade";
  };
}
