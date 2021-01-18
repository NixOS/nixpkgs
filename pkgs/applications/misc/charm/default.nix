{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "0cgl5dpyzc4lciij9q9yghppiclrdnrl1jsbizfgh2an3s18ab8k";
  };

  vendorSha256 = "1spzawnk2fslc1m14dp8lx4vpnxwz7xgm1hxbpz4bqlqz1hfd6ax";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
