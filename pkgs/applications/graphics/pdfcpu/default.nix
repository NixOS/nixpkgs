{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "03v4wc531dwmbjqgs3y3ncdn6g3xirv1w6h1mfgglb6sjll8jxp5";
  };

  modSha256 = "1nagb3k2ghfw27g4vcmn7v8s5flg387jpf1l18gw6c44a1xjcivs";

  subPackages = [ "cmd/pdfcpu" ];

  meta = with stdenv.lib; {
    description = "A PDF processor written in Go";
    homepage = https://pdfcpu.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}

