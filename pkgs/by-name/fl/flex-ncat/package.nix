{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.5-2025031901";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-hbsrs9lgpxNqG8mmXsft01LmpX4dBpl1ncpdTWBgrUQ=";
  };

  vendorHash = "sha256-RqQMCP9rmdTG5AXLXkIQz0vE7qF+3RZ1BDdVRYoHHQs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
}
