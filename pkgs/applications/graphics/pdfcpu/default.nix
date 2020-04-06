{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a7d36hzcvj68apzc726r2vqsjyrkcynxif5laarxapm6p67g3z4";
  };

  modSha256 = "0ak34wr5cbcvblndslsxdd24vfj3h02xqjqnj5amkll5iqn5mzi1";

  subPackages = [ "cmd/pdfcpu" ];

  meta = with stdenv.lib; {
    description = "A PDF processor written in Go";
    homepage = https://pdfcpu.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}

