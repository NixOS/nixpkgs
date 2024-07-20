{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "dwfv";
  version = "0.4.1";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-JzOD0QQfDfIkJQATxGpyJBrFg5l6lkkAXY2qv9bir3c=";
  };

  cargoSha256 = "1z51yx3psdxdzmwny0rzlch5hjx2pssll73q79qij2bc7wgyjscy";

  meta = with lib; {
    description = "Simple digital waveform viewer with vi-like key bindings";
    mainProgram = "dwfv";
    homepage = "https://github.com/psurply/dwfv";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
