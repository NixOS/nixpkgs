# package.nix
{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
, libevdev
}:

rustPlatform.buildRustPackage rec {
  pname = "bloody-mouse-fix";
  version = "1.1";

  src = fetchFromGitHub {
  owner = "ItsBenyaamin";
  repo = "linux_mouse_fix";
  rev = "v${version}";
  hash = "sha256-snz7y6mFXOUfu8mKaluLOm8pCKig8O+AF9cvIjHE0R0=";
};

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "uinput-0.1.3" = "sha256-+Y4JOxhkPHZwyKuPAcOmGvkdnWtiEVw6OMY87CWA5mU=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    substituteInPlace src/main.rs \
      --replace-fail 'if current_path != EXE_DIR {' 'if false { // Patch: path check disabled for NixOS'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ udev libevdev ];

  meta = with lib; {
    description = "Fix automatically Linux mouse movement issue due to multi event file";
    homepage = "https://github.com/ItsBenyaamin/linux_mouse_fix";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ yafizrug ];
    platforms = platforms.linux;
  };
}
