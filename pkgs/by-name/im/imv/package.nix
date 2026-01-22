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
  tinyxxd,
  icu,
  pango,
  inih,
  withWindowSystem ? if stdenv.hostPlatform.isLinux then "all" else "x11",
  xorg,
  libxkbcommon,
  libGL,
  wayland,
  wayland-protocols,
  wayland-scanner,
  versionCheckHook,
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
}:

let
  windowSystems = {
    all = windowSystems.x11 ++ windowSystems.wayland;
    x11 = [
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

  backendFlags = map (b: lib.mesonEnable b (lib.elem b withBackends)) (lib.attrNames backends);
in

# check that given window system is valid
assert lib.assertOneOf "withWindowSystem" withWindowSystem (builtins.attrNames windowSystems);
# check that every given backend is valid
assert builtins.all (
  b: lib.assertOneOf "each backend" b (builtins.attrNames backends)
) withBackends;

stdenv.mkDerivation (finalAttrs: {
  pname = "imv";
  version = "5.0.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~exec64";
    repo = "imv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2JTs/hj6t9wEZKoUpcLDFulbdU/grDlQkuEAE7uayDs=";
  };

  mesonFlags = [
    (lib.mesonOption "windows" withWindowSystem)
    (lib.mesonEnable "test" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "man" true)
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
    libGL
    icu
    libxkbcommon
    pango
    inih
  ]
  ++ windowSystems."${withWindowSystem}"
  ++ map (b: backends."${b}") withBackends;

  doCheck = true;
  nativeCheckInputs = [
    tinyxxd
  ];
  checkInputs = [
    cmocka
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

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
