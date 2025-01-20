{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  name = "alsa-topology-conf-${version}";
  version = "1.2.5.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${name}.tar.bz2";
    hash = "sha256-98W64VRavNc4JLyX9OcsNA4Rq+oYi6DxwG9eCtd2sXk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r topology $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA topology configuration files";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}
