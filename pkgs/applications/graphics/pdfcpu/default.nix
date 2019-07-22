{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hhrutter";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cg17nph3qv1ca86j3wcd33vqs6clkzi6y2nrajmk7dq5vbzr6nn";
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

