{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "ddate";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "bo0ts";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1qchxnxvghbma6gp1g78wnjxsri0b72ha9axyk31cplssl7yn73f";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/bo0ts/ddate";
    description = "Discordian version of the date program";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.all;
    mainProgram = "ddate";
  };
}
