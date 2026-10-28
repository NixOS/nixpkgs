{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,
  wrapGAppsHook3,
  installShellFiles,

  # buildInputs
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "piscope";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "piscope";
    tag = "V${finalAttrs.version}";
    hash = "sha256-VDrx/RLSpMhyD64PmdeWVacb9LleHakcy7D6zFxeyhw=";
  };
  # Fix FHS paths
  postPatch = ''
    substituteInPlace piscope.c \
      --replace-fail /usr/share/piscope $out/share/piscope
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    installShellFiles
  ];
  buildInputs = [
    gtk3
  ];
  # Upstream's Makefile assumes FHS
  installPhase = ''
    runHook preInstall

    installBin piscope
    install -D -m 0644 piscope.glade $out/share/piscope/piscope.glade

    runHook postInstall
  '';

  meta = {
    homepage = "http://abyz.me.uk/rpi/pigpio/piscope.html";
    description = "Logic analyser (digital waveform viewer) for the Raspberry";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux;
  };
})
