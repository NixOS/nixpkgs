{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  qt = buildGoModule {
    pname = "qt";
    version = "0-unstable-2024-03-04";

    src = fetchFromGitHub {
      owner = "akiyosi";
      repo = "qt";
      rev = "b43fff373ad5827e64511dc28e989de2381ed258";
      hash = "sha256-cFiI5hD6trQiGDi+Viqk62km9wvkXHJpJzU2YDcVbzU=";
    };

    vendorHash = "";
  };
in
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

  preBuild = ''
    ${qt}/bin/qtsetup
  '';

  meta = {
    description = " A GUI frontend for neovim.";
    homepage = "https://github.com/akiyosi/goneovim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justdeeevin ];
    mainProgram = "goneovim";
    platforms = lib.platforms.linux;
  };
}
