{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "hhrutter";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vmmc7nnvpvsf92yi69rvqif1irkpya2shqyz49sa3s42jh1446b";
  };

  modSha256 = "0cz4gs88s9z2yv1gc9ap92vv2j93ab6kr25zjgl2r7z6clbl5fzp";

  subPackages = [ "cmd/pdfcpu" ];

  meta = with stdenv.lib; {
    description = "A PDF processor written in Go";
    homepage = https://pdfcpu.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}

