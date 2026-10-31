{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  installFonts,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "culmus-fancy";
  version = "0.0.20240129.1";

  # Each font is maintained independently and upstream doesn't provide
  # versioned links. Downloading directly would break on update.
  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "hebrew-team";
    repo = "culmus-fancy";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-ZefHhr1rwCVdLbmvQI305w2k2kDxJURD0KUG8mmEwoc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ installFonts ];

  passthru.updateScript = gitUpdater { rev-prefix = "debian/"; };

  meta = {
    homepage = "https://culmus.sourceforge.io/index.html";
    description = "Additional Fonts from the Culmus Project";
    longDescription = "The Fancy Fonts and Taamey Culmus are maintained independently and not included in the standard Culmus distribution.";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.ytg123 ];
  };
})
