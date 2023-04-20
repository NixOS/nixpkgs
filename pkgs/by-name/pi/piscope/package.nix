{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "piscope";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "piscope";
    # Version is embedded in source code, no tag or github release available
    rev = "V${finalAttrs.version}";
    hash = "sha256-VDrx/RLSpMhyD64PmdeWVacb9LleHakcy7D6zFxeyhw=";
  };
  # Fix FHS paths
  postConfigure = ''
    substituteInPlace piscope.c \
      --replace /usr/share/piscope $out/share/piscope
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [ gtk3 ];
  # Upstream's Makefile assumes FHS
  installPhase = ''
    runHook preInstall

    install -D -m 0755 piscope       $out/bin/piscope
    install -D -m 0644 piscope.glade $out/share/piscope/piscope.glade

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://abyz.me.uk/rpi/pigpio/piscope.html";
    description = "A logic analyser (digital waveform viewer) for the Raspberry";
    license = licenses.unlicense;
    maintainers = with maintainers; [ doronbehar ];
  };
})
