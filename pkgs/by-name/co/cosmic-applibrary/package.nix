{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, just
, pkg-config
, makeBinaryWrapper
, libxkbcommon
, wayland
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-applibrary";
  version = "0-unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "e214e9867876c96b24568d8a45aaca2936269d9b";
    hash = "sha256-fZxDRktiHHmj7X3e5VyJJMO081auOpSMSsBnJdhhtR8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-ETNVJ4y7EraAlU9XEZGNNPdyWt1WIURr1dSH6hQ0Pos=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-CACVCnyFgefkpDlll6IeaPWB8a3gbF6BW8MnlkytV8o=";
      "switcheroo-control-0.1.0" = "sha256-ztZ5HD1hEOvsUSn94ZbbJ6SY9Jbsm8iGHR70GuAnEaQ=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "cosmic-text-0.11.1" = "sha256-lyBl0VAzcKBqLeCPrA28VW6O0MWXazJg1b11YuBR65U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
    };
  };

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  postInstall = ''
    wrapProgram $out/bin/cosmic-app-library \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
