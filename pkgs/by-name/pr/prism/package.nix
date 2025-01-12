{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "prism";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "prism";
    tag = "v${version}";
    hash = "sha256-IRR7Gu+wGUUYyFfhc003QVlEaWCJPmi6XYVUN6Q6+GA=";
  };

  vendorHash = "sha256-uKtVifw4dxJdVvHxytL+9qjXHEdTyiz8U8n/95MObdY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RTMP stream recaster/splitter";
    homepage = "https://github.com/muesli/prism";
    changelog = "https://github.com/muesli/prism/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "prism";
  };
}
