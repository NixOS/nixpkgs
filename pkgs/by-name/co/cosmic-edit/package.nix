{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeBinaryWrapper,
  cosmic-icons,
  just,
  pkg-config,
  libxkbcommon,
  glib,
  gtk3,
  libinput,
  fontconfig,
  freetype,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-edit";
  version = "0-unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "c1944f9c15812ce842c91a77e228cc22a0f49f18";
    hash = "sha256-wJnBfBQKYmpJBSboGKtlwew17clE60ac2AismIe1XaA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-GHjoLGF9hFJRpf5i+TwflRnh8N+oWyWZ9fqgRFLXQsw=";
      "cosmic-syntax-theme-0.1.0" = "sha256-9Vf2s5Ry2hco80EbXOuVLwvOWygRiuaRD4tTImWooSg=";
      "cosmic-text-0.10.0" = "sha256-PHz5jUecK889E88Y20XUe2adTUO8ElnoV7IIcaohMUw=";
      "glyphon-0.3.0" = "sha256-JGkNIfj1HjOF8kGxqJPNq/JO+NhZD6XrZ4KmkXEP6Xc=";
      "sctk-adwaita-0.5.4" = "sha256-yK0F2w/0nxyKrSiHZbx7+aPNY2vlFs7s8nu/COp2KqQ=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "smithay-client-toolkit-0.16.1" = "sha256-z7EZThbh7YmKzAACv181zaEZmWxTrMkFRzP0nfsHK6c=";
      "systemicons-0.7.0" = "sha256-zzAI+6mnpQOh+3mX7/sJ+w4a7uX27RduQ99PNxLNF78=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.28.6" = "sha256-FhW6d2XnXCGJUMoT9EMQew9/OPXiehy/JraeCiVd76M=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ just pkg-config makeBinaryWrapper ];
  buildInputs = [
    libxkbcommon
    xorg.libX11
    libinput
    fontconfig
    freetype
    wayland
    glib
    gtk3
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/${pname}" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ xorg.libX11 ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary ];
    platforms = platforms.linux;
  };
}
