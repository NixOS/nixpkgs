{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "aw-watcher-window-wayland";
  version = "6108ad3df8e157965a43566fa35cdaf144b1c51b";

  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = pname;
    rev = version;
    hash = "sha256-xl9+k6xJp5/t1QPOYfnBLyYprhhrzjzByDKkT3dtVVQ=";
  };

  cargoPatches = [ ./rustc-serialize-fix.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-pMoWwuOenY/DKItM0fSa5RIdjMHFPHvo5qtKyz8loSQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "WIP window and afk watcher for wayland";
    homepage = "https://github.com/ActivityWatch/aw-watcher-window-wayland";
    license = licenses.mpl20;
    maintainers = with maintainers; [ esau79p ];
    mainProgram = "aw-watcher-window-wayland";
    platforms = platforms.linux;
  };
}
