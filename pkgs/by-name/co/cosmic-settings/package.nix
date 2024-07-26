{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, makeBinaryWrapper
, cosmic-icons
, cosmic-randr
, just
, pkg-config
, libxkbcommon
, libinput
, fontconfig
, freetype
, wayland
, expat
, udev
, util-linux
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings";
  version = "0-unstable-2024-02-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "82ee8a693cb2e1f727aa600f62a24d5de5d685d6";
    hash = "sha256-OGei48Eu0kBXlWwGQaRZULAOnKyrDjCXV8OuWdOmv8E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-2P2NcgDmytvBCMbG8isfZrX+JirMwAz8qjW3BhfhebI=";
      "cosmic-comp-config-0.1.0" = "sha256-btXMVpgf6CKSXuUeNydreibgrRvBwiljYucaoch6RKs=";
      "cosmic-config-0.1.0" = "sha256-QDcU9kVRHJmr8yuHq5C0RahQz0xBMkmDboW9Y2Tsk5s=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-panel-config-0.1.0" = "sha256-gPQ5BsLvhnopnnGeKbUizmgk0yhEEgSD0etX9YEWc5E=";
      "cosmic-randr-shell-0.1.0" = "sha256-t1PM/uIM+lbBwgFsKnRiqPZnlb4dxZnN72MfnW0HU/0=";
      "cosmic-text-0.11.2" = "sha256-EG0jERREWR4MBWKgFmE/t6SpTTQRXK76PPa7+/TAKOA=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-PfuybCDLeRcVCkVxFK2T9BnL2uJz7C4EEPDZ9cWlPqk=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ cmake just pkg-config makeBinaryWrapper ];
  buildInputs = [ libxkbcommon libinput fontconfig freetype wayland expat udev util-linux ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  postInstall = ''
    wrapProgram "$out/bin/cosmic-settings" \
      --prefix PATH : ${lib.makeBinPath [ cosmic-randr ]} \
      --suffix XDG_DATA_DIRS : "$out/share:${cosmic-icons}/share"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
