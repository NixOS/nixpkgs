{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "0mjq0yy60czsw40h5n515qmi6bbvhrddll4sn5r2q1nf9pvviqr6";
  };

  vendorSha256 = "1spzawnk2fslc1m14dp8lx4vpnxwz7xgm1hxbpz4bqlqz1hfd6ax";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
