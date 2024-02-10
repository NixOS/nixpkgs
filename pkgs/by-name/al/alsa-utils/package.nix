{ lib
, stdenv
, fetchurl
, fetchpatch
, alsa-lib
, alsa-plugins
, gettext
, makeWrapper
, ncurses
, libsamplerate
, pciutils
, which
, fftw
, pipewire
, withPipewireLib ? true
, symlinkJoin
}:

let
  plugin-packages = [ alsa-plugins ] ++ lib.optional withPipewireLib pipewire;

  # Create a directory containing symlinks of all ALSA plugins.
  # This is necessary because ALSA_PLUGIN_DIR must reference only one directory.
  plugin-dir = symlinkJoin {
    name = "all-plugins";
    paths = map
      (path: "${path}/lib/alsa-lib")
      plugin-packages;
  };
in
stdenv.mkDerivation rec {
  pname = "alsa-utils";
  version = "1.2.10";

  src = fetchurl {
    url = "mirror://alsa/utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-EEti7H8Cp84WynefSBVhbfHMIZM1A3g6kQe1lE+DBjo=";
  };
  patches = [
    # Backport fixes for musl libc. Remove on next release
    (fetchpatch {
      url = "https://github.com/alsa-project/alsa-utils/commit/8c229270f6bae83b705a03714c46067a7aa57b02.patch";
      hash = "sha256-sUaBHY8EHf4805nF6tyNV5jYXcJf3O+r04VXFu4dUCE=";
    })
    (fetchpatch {
      url = "https://github.com/alsa-project/alsa-utils/commit/0925ad7f09b2dc77015784f9ac2f5e34dd0dd5c3.patch";
      hash = "sha256-bgGU9On82AUbOjo+KN6WfuhqUAWM87OHnKN7plpG284=";
    })
  ];

  nativeBuildInputs = [ gettext makeWrapper ];
  buildInputs = [ alsa-lib ncurses libsamplerate fftw ];

  configureFlags = [ "--disable-xmlto" "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  installFlags = [ "ASOUND_STATE_DIR=$(TMPDIR)/dummy" ];

  postFixup = ''
    mv $out/bin/alsa-info.sh $out/bin/alsa-info
    wrapProgram $out/bin/alsa-info --prefix PATH : "${lib.makeBinPath [ which pciutils ]}"
    wrapProgram $out/bin/aplay --set-default ALSA_PLUGIN_DIR ${plugin-dir}
  '';

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture utils";
    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
