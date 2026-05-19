{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  pixman,
  alsa-lib,
  openssl,
  libxrandr,
  libxfixes,
  libxext,
  libxrender,
  libxinerama,
  libjpeg,
  zlib,
  spice-protocol,
  python3,
  glib,
  cyrus_sasl,
  libcacard,
  lz4,
  libopus,
  gst_all_1,
  orc,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spice";
  version = "0.16.0";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/spice-server/spice-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-Cm7JUo8FNxJhu7LUb/Nee1xF/4m7l1qZr5Wl8g/0cX0=";
  };

  patches = [
    ./remove-rt-on-darwin.patch
  ];

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    python3
    python3.pkgs.pyparsing
  ];

  buildInputs = [
    cyrus_sasl
    glib
    gst_all_1.gst-plugins-base
    libxext
    libxfixes
    libxinerama
    libxrandr
    libxrender
    libcacard
    libjpeg
    libopus
    lz4
    openssl
    orc
    pixman
    python3.pkgs.pyparsing
    spice-protocol
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gdk-pixbuf
  ];

  env.NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  mesonFlags = [
    "-Dgstreamer=1.0"
  ];

  postPatch = ''
    patchShebangs build-aux
  '';

  postInstall = ''
    ln -s spice-server $out/include/spice
  '';

  meta = {
    description = "Complete open source solution for interaction with virtualized desktop devices";
    longDescription = ''
      The Spice project aims to provide a complete open source solution for interaction
      with virtualized desktop devices.The Spice project deals with both the virtualized
      devices and the front-end. Interaction between front-end and back-end is done using
      VD-Interfaces. The VD-Interfaces (VDI) enable both ends of the solution to be easily
      utilized by a third-party component.
    '';
    homepage = "https://www.spice-space.org/";
    license = lib.licenses.lgpl21;

    maintainers = with lib.maintainers; [
      atemu
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
