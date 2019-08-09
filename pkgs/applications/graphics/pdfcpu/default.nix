{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "hhrutter";
    repo = pname;
    rev = "v${version}";
    sha256 = "1knvi0v9nfzw40dayrw5cjidg9h900143v1pi6240yd7r7isx348";
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

