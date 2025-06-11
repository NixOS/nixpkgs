{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  caps,
  ladspaH,
}:

stdenv.mkDerivation rec {
  pname = "alsaequal";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "bassdr";
    repo = "alsaequal";
    tag = "v${version}";
    hash = "sha256-jI+w/jCFslQSNeIS7mwb+LZSawU4XjbSNNgpvuShH1g=";
  };

  buildInputs = [
    alsa-lib
    ladspaH
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  # Borrowed from Arch Linux's AUR
  patches = [
    # Adds executable permissions to resulting libraries
    # and changes their destination directory from "usr/lib/alsa-lib" to "lib/alsa-lib" to better align with nixpkgs filesystem hierarchy.
    ./makefile.patch
  ];

  postPatch = ''
    sed -i 's#/usr/lib/ladspa/caps\.so#${caps}/lib/ladspa/caps\.so#g' ctl_equal.c pcm_equal.c
  '';

  preInstall = ''
    mkdir -p "$out/lib/alsa-lib"
  '';

  meta = with lib; {
    description = "Real-time adjustable equalizer plugin for ALSA";
    homepage = "https://github.com/bassdr/alsaequal";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ymeister ];
  };
}
