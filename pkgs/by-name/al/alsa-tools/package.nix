{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fltk13,
  gtk2,
  gtk3,
  makeWrapper,
  pkg-config,
  psmisc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-tools";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://alsa/tools/alsa-tools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-CRXJY0pQL9NlXKnFdNJZvJ55mD2R1Frqz/bzwA+K4+k=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fltk13
    gtk2
    gtk3
    psmisc
  ];

  env.TOOLSET = lib.concatStringsSep " " [
    "as10k1"
    "echomixer"
    "envy24control"
    "hda-verb"
    "hdajackretask"
    "hdajacksensetest"
    "hdspconf"
    "hdsploader"
    "hdspmixer"
    # "hwmixvolume" # Requires old, unmaintained, abandoned EOL Python 2
    "ld10k1"
    # "qlo10k1" # needs Qt
    "mixartloader"
    "pcxhrloader"
    "rmedigicontrol"
    "sb16_csp"
    # "seq" # mysterious configure error
    "sscape_ctl"
    "us428control"
    # "usx2yloader" # tries to create /etc/hotplug/usb
    "vxloader"
  ];

  configurePhase = ''
    runHook preConfigure

    for tool in $TOOLSET; do
      echo "Configuring $tool:"
      pushd "$tool"
      ./configure --prefix="$out"
      popd
    done

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    for tool in $TOOLSET; do
      echo "Building $tool:"
      pushd "$tool"
      make
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for tool in $TOOLSET; do
      echo "Installing $tool:"
      pushd "$tool"
      make install
      popd
    done

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/bin/hdajackretask \
      --prefix PATH : ${lib.makeBinPath [ psmisc ]}

    runHook postFixup
  '';

  meta = {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA Tools";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
