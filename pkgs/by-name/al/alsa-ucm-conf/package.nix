{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
  version = "1.2.10";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-nCHj8B/wC6p1jfF+hnzTbiTrtBpr7ElzfpkQXhbyrpc=";
  };

  patches = [
    (fetchpatch {
      # ToDo: Remove this patch in the next package upgrade
      # Fixes SplitPCM to make some audio devices work with alsa-ucm-conf v1.2.10 again
      name = "alsa-ucm-conf-splitpcm-device-argument-fix.patch";
      url = "https://github.com/alsa-project/alsa-ucm-conf/commit/b68aa52acdd2763fedad5eec0f435fbf43e5ccc6.patch";
      hash = "sha256-8WE4+uhi4W7cCSZYmL7uFpcHJ9muX09UkGXyZIpEd9I=";
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
