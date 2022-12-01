{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geek-life";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ajaxray";
    repo = "geek-life";
    rev = "v${version}";
    sha256 = "083y2kv5vb217ghy9g2qylqgdgbjjggjj3cq454csnn3cjgq9zfh";
  };

  vendorSha256 = "05fcnmg2rygccf65r8js6kbijx740vfnvbrc035bjs1jvdw29h9j";

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
