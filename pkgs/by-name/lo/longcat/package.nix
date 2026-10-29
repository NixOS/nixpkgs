{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.0.17";
in
buildGoModule {
  pname = "longcat";
  inherit version;

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "longcat";
    tag = "v${version}";
    hash = "sha256-77pYs1IZiUlUGricE4K/zA/vKiihUZnrpyNPEhZjMas=";
  };

  vendorHash = "sha256-VcNhzQyhd7gDvlrz7Lh2QRUkMjZj40s2hanNP6gsnMs=";

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
