{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-OHwBzzDioWdte49ysmgc8hmrynDdHsKp4zrdW/P+roE=";
  };

  patches = [
    (fetchpatch {
      # TODO: Remove this patch in the next package upgrade
      name = "rt1318-fix-one.patch";
      url = "https://github.com/alsa-project/alsa-ucm-conf/commit/7e22b7c214d346bd156131f3e6c6a5900bbf116d.patch";
      hash = "sha256-5X0ANXTSRnC9jkvMLl7lA5TBV3d1nwWE57DP6TwliII=";
    })
    (fetchpatch {
      # TODO: Remove this patch in the next package upgrade
      name = "rt1318-fix-two.patch";
      url = "https://github.com/alsa-project/alsa-ucm-conf/commit/4e0fcc79b7d517a957e12f02ecae5f3c69fa94dc.patch";
      hash = "sha256-cuZPEEqb8+d1Ak2tA+LVEh6gtGt1X+LiAnfFYMIDCXY=";
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}
