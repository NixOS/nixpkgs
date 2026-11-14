{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.0.21";
in
buildGoModule {
  pname = "longcat";
  inherit version;

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "longcat";
    tag = "v${version}";
    hash = "sha256-2SldcqugPr1muJgSr2JfSro6wtItaXX13w/IsJHZz4Y=";
  };

  vendorHash = "sha256-dgQhSZEWWhS3ee9rhXVdB8toj6mGWbp3pIB2PEasy28=";

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
