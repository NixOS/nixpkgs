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
, pipewire
, pulseaudio
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
  version = "1.0.0-alpha.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "epoch-${version}";
    hash = "sha256-L2PMy+9yOqZ/bvTqFIrwKXx90LHdygJ7IlPWCIW2Wp0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "bluez-zbus-0.1.0" = "sha256-mklNPKVMO6iFrxki2DwiL5K78KiWpGxksisYldaASIE=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-bg-config-0.1.0" = "sha256-bmcMZIURozlptsR4si62NTmexqaCX1Yj5bYj49GDehQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-qa/wqU4CBVPA0ko4TgbsGUTIW4QoKqJMDUMQ163oWo4=";
      "cosmic-config-0.1.0" = "sha256-saWOdcq+W721wPmkQc92aXLE+uKWRN1851/f0cYW/QY=";
      "cosmic-idle-config-0.1.0" = "sha256-ta2BmFTmWZE8OARu5hwj4AibtswKyjElUK4CayLbpDY=";
      "cosmic-panel-config-0.1.0" = "sha256-sIJSD/clSqF7H/jEl7XzXn7qpzpI5ez9xM3ApiXFNqw=";
      "cosmic-protocols-0.1.0" = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
      "cosmic-randr-0.1.0" = "sha256-xakK4APhlNKuWbCMP6nJXLyOaQ0hFCvzOht3P8CkV/0=";
      "cosmic-settings-config-0.1.0" = "sha256-QnRicNbKKAjq12hPE6QbtyH0rV33H3RPHdISYjHX7yw=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-fCWGXR+Ky5W/D46OvZX7VyrmOjlxliZCHgsvPS6MgXY=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "fast_image_resize-5.0.0" = "sha256-EQBjJlPfoPEFqEYf840jAUfHsGABbsGlGgJ+qwv68Ds=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook cmake just pkg-config makeBinaryWrapper ];
  buildInputs = [ libxkbcommon libinput fontconfig libglvnd mesa freetype pipewire pulseaudio expat udev util-linux wayland ];

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
