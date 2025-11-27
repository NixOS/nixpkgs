{
  stdenv,
  lib,
  fetchFromSourcehut,
  asciidoc,
  cmocka,
  docbook_xsl,
  libxslt,
  meson,
  ninja,
  pkg-config,
  icu,
  pango,
  inih,
  withWindowSystem ? if stdenv.hostPlatform.isLinux then "all" else "x11",
  xorg,
  libxkbcommon,
  libGLU,
  wayland,
  wayland-protocols,
  withBackends ? [
    "farbfeld"
    "libjxl"
    "libtiff"
    "libjpeg"
    "libpng"
    "librsvg"
    "libheif"
    "libnsgif"
    "libnsbmp"
    "libwebp"
    "qoi"
  ],
  libtiff,
  libjpeg_turbo,
  libjxl,
  libpng,
  librsvg,
  libnsgif,
  libheif,
  libnsbmp,
  libwebp,
  qoi,
  wayland-scanner,
  fetchpatch,
}:

let
  windowSystems = {
    all = windowSystems.x11 ++ windowSystems.wayland;
    x11 = [
      libGLU
      xorg.libxcb
      xorg.libX11
    ];
    wayland = [
      wayland
      wayland-scanner
      wayland-protocols
    ];
  };

  backends = {
    inherit
      libtiff
      libpng
      librsvg
      libheif
      libjxl
      libnsgif
      libnsbmp
      libwebp
      qoi
      ;
    farbfeld = null; # builtin
    libjpeg = libjpeg_turbo;
  };

  backendFlags = map (
    b: if builtins.elem b withBackends then "-D${b}=enabled" else "-D${b}=disabled"
  ) (builtins.attrNames backends);
in

# check that given window system is valid
assert lib.assertOneOf "withWindowSystem" withWindowSystem (builtins.attrNames windowSystems);
# check that every given backend is valid
assert builtins.all (
  b: lib.assertOneOf "each backend" b (builtins.attrNames backends)
) withBackends;

stdenv.mkDerivation (finalAttrs: {
  pname = "imv";
  version = "5.0.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~exec64";
    repo = "imv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sOlWSv1GqdYzooTvcJjXxJI3pwWWJnlUpbGZgUAFYm0=";
  };

  patches = [
    # Fixes Wayland SIGSEGV (https://todo.sr.ht/~exec64/imv/80); remove after next release
    (fetchpatch {
      url = "https://git.sr.ht/~exec64/imv/commit/2dc80ccc64b6e1a315c6c2a06c26fc0138db3a13.patch";
      hash = "sha256-EjnKwJ9bM+VyUPGuy2YHPWleLmQ/DGHHjY/QmnfRpQ4=";
    })
  ];

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
    icu
    libxkbcommon
    pango
    inih
  ]
  ++ windowSystems."${withWindowSystem}"
  ++ map (b: backends."${b}") withBackends;

  postFixup = lib.optionalString (withWindowSystem == "all") ''
    # The `bin/imv` script assumes imv-wayland or imv-x11 in PATH,
    # so we have to fix those to the binaries we installed into the /nix/store

    substituteInPlace "$out/bin/imv" \
      --replace-fail "imv-wayland" "$out/bin/imv-wayland" \
      --replace-fail "imv-x11" "$out/bin/imv-x11"
  '';

  doCheck = true;

  meta = {
    description = "Command line image viewer for tiling window managers";
    homepage = "https://sr.ht/~exec64/imv/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rnhmjoj
      markus1189
    ];
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
    mainProgram = "imv";
  };
})
