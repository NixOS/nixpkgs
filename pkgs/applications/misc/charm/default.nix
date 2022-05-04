{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-XXKzK5MXJsB3LE7iE5BqnLm0hPs7WbyHR0x9aTldrj4=";
  };

  vendorSha256 = "sha256-6PGdM7aa1BGNZc3M35PJpmrlPUqkykxfTELdgeKcJD4=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
