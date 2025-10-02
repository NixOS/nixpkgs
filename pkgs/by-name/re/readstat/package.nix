{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "readstat";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "WizardMac";
    repo = "ReadStat";
    rev = "v${version}";
    sha256 = "sha256-4lRJgZPB2gfaQ9fQKvDDpGhy1eDNT/nT1QmeZlCmCis=";
  };

  patches = [
    # Remove `gettext` requirement
    # https://github.com/WizardMac/ReadStat/issues/341
    (fetchpatch {
      url = "https://github.com/WizardMac/ReadStat/pull/342/commits/b5512b32d3b3c39e2f0c322df1339a3c61f73712.patch";
      hash = "sha256-k1yeplrx3pFPl5qzLfsAaj+qunv1BqOZypA05xSolaQ=";
    })

    # Add (void) to remove -Wstrict-prototypes warnings
    (fetchpatch {
      url = "https://github.com/WizardMac/ReadStat/commit/211c342a1cfe46fb7fb984730dd7a29ff4752f35.patch";
      hash = "sha256-nkaEgusylVu7NtzSzBklBuOnqO9qJPovf0qn9tTE6ls=";
    })

    # Backport use-after-free:
    #   https://github.com/WizardMac/ReadStat/pull/298
    (fetchpatch {
      url = "https://github.com/WizardMac/ReadStat/commit/718d49155e327471ed9bf4a8c157f849f285b46c.patch";
      hash = "sha256-9hmuFa05b4JlxSzquIxXArOGhbi27A+3y5gH1IDg+R0=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/WizardMac/ReadStat";
    description = "Command-line tool (+ C library) for converting SAS, Stata, and SPSS files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
    platforms = lib.platforms.all;
  };
}
