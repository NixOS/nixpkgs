{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "clapboard";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "clapboard";
    rev = "v${version}";
    hash = "sha256-TM07BcluIh+MEcVg1ApZu85rj36ZBUfn125A0eALNMo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uPMaw36y9773LTu02muLot8I42VM2GE/MJSAHClLNgs=";

  meta = with lib; {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "clapboard";
  };
}
