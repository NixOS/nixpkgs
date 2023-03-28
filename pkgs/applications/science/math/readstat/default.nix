{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libiconv }:

stdenv.mkDerivation rec {
  pname = "readstat";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "WizardMac";
    repo = "ReadStat";
    rev = "v${version}";
    sha256 = "sha256-4lRJgZPB2gfaQ9fQKvDDpGhy1eDNT/nT1QmeZlCmCis=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ libiconv ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/WizardMac/ReadStat";
    description = "Command-line tool (+ C library) for converting SAS, Stata, and SPSS files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
