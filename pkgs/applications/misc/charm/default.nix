{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "1q5c2qka4srqj82f50iwmcj2j0yw2msz5dmrx2avqppp3fyi9jz3";
  };

  vendorSha256 = "1xycgzx706kyz37z3517p98129iy7py7zdizz34k38fvfpila5q5";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
