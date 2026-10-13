{
  cairo,
  fetchFromGitHub,
  freetype,
  lib,
  libx11,
  libsndfile,
  pkg-config,
  stdenv,
  xorgproto,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loadbox";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "LoadBox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dYwJOazC/osLjfVsxbFa0lRMeFXhXCAZViEWQJEKJPE=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    xxd
  ];

  buildInputs = [
    cairo
    freetype
    libx11
    libsndfile
    xorgproto
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CLAP_INSTAL_DIR=$(out)/lib/clap"
    "VST2_INSTAL_DIR=$(out)/lib/vst"
    "VST3_INSTALL_DIR=$(out)/lib/vst3"
    "user=root"
    "STRIP=:"
    "XXDI=xxd -i"
    "HAVE_XXD=1"
    "PKGCONFIG=$(PKG_CONFIG)"
  ];

  postPatch = ''
    substituteInPlace LoadBox/makefile \
      --replace-fail "-flto=auto" "" \
      --replace-fail "pkg-config" "\$(PKGCONFIG)" \
      --replace-fail "\$(UNAME_M)-\$(ARCH)" "\$(TARGET_ARCH)-\$(ARCH)"

    substituteInPlace libxputty/Build/Makefile \
      --replace-fail "pkg-config" "\$(PKGCONFIG)"
  '';

  meta = {
    homepage = "https://github.com/brummer10/LoadBox";
    description = "Stereo IR / NAM plugin";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
  };
})
