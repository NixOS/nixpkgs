{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "missidentify";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/missidentify/missidentify/missidentify-${finalAttrs.version}/missidentify-${finalAttrs.version}.tar.gz";
    hash = "sha256-nnIRN8hpKM0IZCe0HUrrJGrxvBYKeBmdU168rlo8op0=";
  };

  patches = [
    # define PATH_MAX variable to fix a FTBFS in Hurd.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/missidentify/-/raw/14b7169c3157dbad65fc80fdd82ec6634df20ffd/debian/patches/fix-FTBFS-Hurd.patch";
      hash = "sha256-yn3UMFTCGaOOJM4alxQVsFSgcs6P7ivD8/OAmCtj7Z8=";
    })
    # fix a hyphen used as minus sign and a typo in manpage.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/missidentify/-/raw/14b7169c3157dbad65fc80fdd82ec6634df20ffd/debian/patches/fix-manpage.patch";
      hash = "sha256-TwizpORqGqM8aPlotOFJ5cPAE6A9HywEVTBGRcKjxo4=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "--build=arm" ];

  meta = with lib; {
    description = "Find Win32 applications";
    mainProgram = "missidentify";
    homepage = "https://missidentify.sourceforge.net";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
})
