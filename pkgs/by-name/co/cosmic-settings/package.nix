{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, makeBinaryWrapper
, mesa
, libglvnd
, cosmic-icons
, cosmic-randr
, just
, pkg-config
, libxkbcommon
, libinput
, fontconfig
, freetype
, pipewire
, pulseaudio
, wayland
, expat
, udev
, util-linux
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "epoch-${version}";
    hash = "sha256-+/PnBzulH3AlWwWJ3B8Ommt79fZ8ZQxNb6vQWYvB7zc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "bluez-zbus-0.1.0" = "sha256-6cEgFfkBxEpIo8LsvKDR2khMdhEz/dp2oYJXXBiC9zg=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-lAFAZBo5FnXgJV3MrZhaYmBxqtH1E7+Huj53ho/hPik=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-IbGMp+4nRg4v5yRvp3ujGx7+nJ6wJmly6dZBXbQAnr8=";
      "cosmic-config-0.1.0" = "sha256-gXrMEoAN+7nYAEcs4w6wROhQTjMCxkGn+muJutktLyk=";
      "cosmic-panel-config-0.1.0" = "sha256-PBkYCwZlZ0UPJ3irOD2PC3zfdjZ+/EnVurGsAlAs6xo=";
      "cosmic-protocols-0.1.0" = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
      "cosmic-randr-0.1.0" = "sha256-g9zoqjPHRv6Tw/Xn8VtFS3H/66tfHSl/DR2lH3Z2ysA=";
      "cosmic-settings-config-0.1.0" = "sha256-mtnMqG3aUSgtN3+Blj3w90UsX8NUu/QlzYgr64KPE9s=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-Mmyx3q18BP3j5sUeyyNytmBEBzdJWTmy6AgAGCFe90c=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook cmake just pkg-config makeBinaryWrapper ];
  buildInputs = [ libxkbcommon libinput fontconfig libglvnd mesa freetype wayland pipewire pulseaudio expat udev util-linux wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
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
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
