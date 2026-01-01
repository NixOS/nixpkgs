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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://www.alsa-project.org/";
    description = "ALSA topology configuration files";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.roastiek ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
=======
    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux ++ platforms.freebsd;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
