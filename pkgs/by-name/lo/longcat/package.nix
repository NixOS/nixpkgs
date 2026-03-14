{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.0.13";
in
buildGoModule {
  pname = "longcat";
  inherit version;

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "longcat";
    tag = "v${version}";
    hash = "sha256-QKtK7v2+Q5/jZrH1m6u9mwgwMQoaLv3pIRc+hYQn4k0=";
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
