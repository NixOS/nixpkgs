{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  alsa-lib,
  cmake,
  gtk2,
  libjack2,
  gnome2,
  libpthreadstubs,
  libsamplerate,
  libsndfile,
  libtool,
  libxml2,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "petri-foo";
  version = "0.1.87";

  src = fetchurl {
    url = "mirror://sourceforge/petri-foo/petri-foo-${finalAttrs.version}.tar.bz2";
    sha256 = "0b25iicgn8c42487fdw32ycfrll1pm2zjgy5djvgw6mfcaa4gizh";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toollchain support:
    #  https://github.com/petri-foo/Petri-Foo/pull/43
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/petri-foo/Petri-Foo/commit/6a3256c9b619b1fed18ad15063f110e8d91aa6fe.patch";
      sha256 = "05yc4g22iwnd054jmvihrl461yr0cxnghslfrbhan6bac6fcvlal";
    })
  ];

  # See https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    gtk2
    libjack2
    gnome2.libgnomecanvas
    libpthreadstubs
    libsamplerate
    libsndfile
    libtool
    libxml2
    openssl
  ];

  meta = {
    description = "MIDI controllable audio sampler";
    longDescription = "a fork of Specimen";
    homepage = "https://petri-foo.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "petri-foo";
  };
})
