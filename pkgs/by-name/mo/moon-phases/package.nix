{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "moon-phases";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8ZdtM246aqc49Q3ygMGk51LIzRA8RIdlaistbKUj3yY=";
  };

  cargoHash = "sha256-8Ada1KBGO1q61dg+4NMJ1Sbipr3ATSP5PO14oQ/QWGs=";

  meta = with lib; {
    description = "Command-line/WM bar tool to display the moon phase at a certain date";
    homepage = "https://github.com/mirrorwitch/moon-phases";
    license = licenses.acsl14;
    maintainers = with maintainers; [ mirrorwitch ];
    mainProgram = "moon-phases";
  };
}
