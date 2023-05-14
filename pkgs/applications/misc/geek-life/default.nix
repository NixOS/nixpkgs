{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geek-life";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ajaxray";
    repo = "geek-life";
    rev = "v${version}";
    sha256 = "sha256-7B/4pDOVXef2MaWKvzkUZH0/KM/O1gJjI3xPjEXqc/E=";
  };

  vendorHash = "sha256-U80Yb8YXKQ8KJf+FxkC0EIUFKP4PKAFRtKTCvXSc0WI=";

  postInstall = ''
    mv $out/bin/app $out/bin/geek-life
  '';

  meta = with lib; {
    homepage = "https://github.com/ajaxray/geek-life";
    description = "The Todo List / Task Manager for Geeks in command line";
    maintainers = with maintainers; [ noisersup ];
    license = licenses.mit;
  };
}
