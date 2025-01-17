{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "goneovim";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "akiyosi";
    repo = "goneovim";
    rev = "v${version}";
    hash = "sha256-eBhsPvp9WdV+IhZD5+1LXvuEF88IpQYxxQKE41uWfDM=";
  };

  vendorHash = "sha256-n4R6dCXb7bBPfVNl5mkV+t+bkO9G/AT9NzBmlIJZq+M=";

  patches = [ ./version.patch ];

  meta = {
    description = " A GUI frontend for neovim.";
    homepage = "https://github.com/akiyosi/goneovim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justdeeevin ];
    mainProgram = "goneovim";
    platforms = lib.platforms.linux;
  };
}
