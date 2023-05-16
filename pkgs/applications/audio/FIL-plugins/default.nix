<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, ladspaH
=======
{ lib, stdenv, fetchurl, ladspaH
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "FIL-plugins";
  version = "0.3.0";
<<<<<<< HEAD

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    hash = "sha256-HAvycSEZZfZwoVp3g7QWcwfbdyZKwWJKBuVmeWTajuk=";
=======
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1scfv9j7jrp50r565haa4rvxn1vk2ss86xssl5qgcr8r45qz42qw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ladspaH ];

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/lib/ladspa "$out/lib/ladspa" \
      --replace g++             "$CXX"
  '';

  preInstall = ''
    mkdir -p "$out/lib/ladspa"
  '';
=======
  patchPhase = ''
    sed -i 's@/usr/bin/install@install@g' Makefile
    sed -i 's@/bin/rm@rm@g' Makefile
    sed -i 's@/usr/lib/ladspa@$(out)/lib/ladspa@g' Makefile
  '';

  preInstall="mkdir -p $out/lib/ladspa";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "a four-band parametric equaliser, which has the nice property of being stable even while parameters are being changed";
    longDescription = ''
      Each section has an active/bypass switch, frequency, bandwidth and gain controls.
      There is also a global bypass switch and gain control.
      The 2nd order resonant filters are implemented using a Mitra-Regalia style lattice filter.
      All switches and controls are internally smoothed, so they can be used 'live' whithout any clicks or zipper noises.
      This should make this plugin a good candidate for use in systems that allow automation of plugin control ports, such as Ardour, or for stage use.
    '';
    version = version;
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/ladspa/index.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
