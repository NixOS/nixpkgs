{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, libiconv }:

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
    (fetchpatch {
      url = "https://github.com/WizardMac/ReadStat/commit/211c342a1cfe46fb7fb984730dd7a29ff4752f35.patch";
      hash = "sha256-nkaEgusylVu7NtzSzBklBuOnqO9qJPovf0qn9tTE6ls=";
    })
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ libiconv ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/WizardMac/ReadStat";
    description = "Command-line tool (+ C library) for converting SAS, Stata, and SPSS files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
    platforms = lib.platforms.all;
  };
}
