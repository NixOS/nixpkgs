{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libiconv }:

stdenv.mkDerivation rec {
  name = "readstat";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "WizardMac";
    repo = "ReadStat";
    rev = "v${version}";
    sha256 = "1r04lq45h1yn34v1mgfiqjfzyaqv4axqlby0nkandamcsqyhc7y4";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ libiconv ];

  meta = {
    homepage = "https://github.com/WizardMac/ReadStat";
    description = "Command-line tool (+ C library) for converting SAS, Stata, and SPSS files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
