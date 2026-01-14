{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.0.12";
in
buildGoModule {
  pname = "longcat";
  inherit version;

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "longcat";
    tag = "v${version}";
    hash = "sha256-MiUkI7qCN/rDJUkBCyET19CH4iYnl1HwKjRZD2dCTVM=";
  };

  vendorHash = "sha256-ka58YOoyBKLX8Z9ak2+rERXsY3rPUaOanfIFErCJCdE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mattn/longcat";
    description = "Renders a picture of a long cat on the terminal";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "longcat";
    maintainers = with lib.maintainers; [
      bubblepipe
    ];
  };
}
