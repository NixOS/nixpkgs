{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

    # C++ does not allow designated initializers to refer to members of
    # anonymous unions. This fails with GCC 16, and was fixed upstream across
    # two merge requests but not yet released.
    # https://gitlab.freedesktop.org/spice/spice/-/merge_requests/246
    (fetchpatch {
      name = "spice-test-display-base-initializer-anonymous-union.patch";
      url = "https://gitlab.freedesktop.org/spice/spice/-/commit/59bc22a40611121b2ea7888bf3c1a501c4fc0b91.patch";
      hash = "sha256-VQ+DrzmIws3EyZU5c0OqMZwMltUvCW34h5oXuHB8YWs=";
    })
    # https://gitlab.freedesktop.org/spice/spice/-/merge_requests/244
    (fetchpatch {
      name = "spice-test-gst-initializer-anonymous-union.patch";
      url = "https://gitlab.freedesktop.org/spice/spice/-/commit/a904cd86430aa555a50730e9389e210637a546c1.patch";
      hash = "sha256-6GGqi+Y4I/oftE8zXuRnX021+r7SrQPUdAdBsCv9MIw=";
    })
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
