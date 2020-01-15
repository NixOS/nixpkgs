{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0inlwrpv5zkcv48g5gq1xdrvd7w1zkhf8p57fpr2cpd7hd3am7n8";
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

