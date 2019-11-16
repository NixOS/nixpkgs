{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fgdq8byb9pp9wiq3dm0vxw32kbspczqnk41agxpzjf303zmv75y";
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

