{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "1nbix7fi6g9jadak5zyx7fdz7d6367aly6fnrs0v98zsl1kxyvx3";
  };

  vendorSha256 = "0lhml6m0j9ksn09j7z4d9pix5aszhndpyqajycwj3apvi3ic90il";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
