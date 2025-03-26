{
  stdenv,
  lib,
  fetchFromSourcehut,
  fetchpatch,
  asciidoc,
  cmocka,
  docbook_xsl,
  libxslt,
  meson,
  ninja,
  pkg-config,
  icu75,
  pango,
  inih,
  withWindowSystem ? if stdenv.hostPlatform.isLinux then "all" else "x11",
  xorg,
  libxkbcommon,
  libGLU,
  wayland,
  withBackends ? [
    "libjxl"
    "libtiff"
    "libjpeg"
    "libpng"
    "librsvg"
    "libheif"
    "libnsgif"
  ],
  freeimage,
  libtiff,
  libjpeg_turbo,
  libjxl,
  libpng,
  librsvg,
  libnsgif,
  libheif,
}:

let
  windowSystems = {
    all = windowSystems.x11 ++ windowSystems.wayland;
    x11 = [
      libGLU
      xorg.libxcb
      xorg.libX11
    ];
    wayland = [ wayland ];
  };

  backends = {
    inherit
      freeimage
      libtiff
      libpng
      librsvg
      libheif
      libjxl
      libnsgif
      ;
    libjpeg = libjpeg_turbo;
  };

  backendFlags = builtins.map (
    b: if builtins.elem b withBackends then "-D${b}=enabled" else "-D${b}=disabled"
  ) (builtins.attrNames backends);
in

# check that given window system is valid
assert lib.assertOneOf "withWindowSystem" withWindowSystem (builtins.attrNames windowSystems);
# check that every given backend is valid
assert builtins.all (
  b: lib.assertOneOf "each backend" b (builtins.attrNames backends)
) withBackends;

stdenv.mkDerivation rec {
  pname = "imv";
  version = "4.5.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~exec64";
    repo = "imv";
    rev = "v${version}";
    sha256 = "sha256-aJ2EXgsS0WUTxMqC1Q+uOWLG8BeuwAyXPmJB/9/NCCU=";
  };

  mesonFlags = [
    "-Dwindows=${withWindowSystem}"
    "-Dtest=enabled"
    "-Dman=enabled"
  ]
  ++ backendFlags;

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cmocka
    icu75
    libxkbcommon
    pango
    inih
  ]
  ++ windowSystems."${withWindowSystem}"
  ++ builtins.map (b: backends."${b}") withBackends;

  patches = [
    (fetchpatch {
      # https://lists.sr.ht/~exec64/imv-devel/patches/55937
      name = "update libnsgif backend";
      url = "https://lists.sr.ht/~exec64/imv-devel/%3C20241113012702.30521-2-reallyjohnreed@gmail.com%3E/raw";
      hash = "sha256-/OQeDfIkPtJIIZwL8jYVRy0B7LSBi9/NvAdPoDm851k=";
    })
  ];

  postInstall = ''
    install -Dm644 ../files/imv.desktop $out/share/applications/
  '';

  postFixup = lib.optionalString (withWindowSystem == "all") ''
    # The `bin/imv` script assumes imv-wayland or imv-x11 in PATH,
    # so we have to fix those to the binaries we installed into the /nix/store

    substituteInPlace "$out/bin/imv" \
      --replace-fail "imv-wayland" "$out/bin/imv-wayland" \
      --replace-fail "imv-x11" "$out/bin/imv-x11"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Command line image viewer for tiling window managers";
    homepage = "https://sr.ht/~exec64/imv/";
    license = licenses.mit;
    maintainers = with maintainers; [
      rnhmjoj
      markus1189
    ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
    mainProgram = "imv";
  };
}
