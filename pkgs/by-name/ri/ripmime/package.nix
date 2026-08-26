{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripmime";
  version = "1.4.1.0";
  src = fetchFromGitHub {
    owner = "inflex";
    repo = "ripMIME";
    tag = "${finalAttrs.version}";
    hash = "sha256-D05cz10NTkgc+d3BzUvEkrmMGV/iw4r6m6tizc5TmaI=";
  };

  preInstall = ''
    sed -i Makefile -e "s@LOCATION=.*@LOCATION=$out@" -e "s@man/man1@share/&@"
    mkdir -p "$out/bin" "$out/share/man/man1"
  '';

  env = {
    NIX_CFLAGS_COMPILE = " -Wno-error ";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  meta = {
    description = "Attachment extractor for MIME messages";
    maintainers = with lib.maintainers; [ raskin ];
    homepage = "https://pldaniels.com/ripmime/";
    platforms = lib.platforms.all;
    mainProgram = "ripmime";
    license = lib.licenses.bsd3;
  };
})
