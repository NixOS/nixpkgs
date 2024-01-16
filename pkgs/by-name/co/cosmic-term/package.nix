{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  cosmic-icons,
  just,
  pkg-config,
  libglvnd,
  libxkbcommon,
  libinput,
  fontconfig,
  freetype,
  xwayland,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-term";
  version = "0-unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "4e0e84a4b11cab5c9bd965e6abd6bca55269db1d";
    hash = "sha256-LqMMgj2Pv80oln2vNRidShyGyxWFeFB01aYqUXsIln0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-GHjoLGF9hFJRpf5i+TwflRnh8N+oWyWZ9fqgRFLXQsw=";
      "cosmic-text-0.10.0" = "sha256-PHz5jUecK889E88Y20XUe2adTUO8ElnoV7IIcaohMUw=";
      "glyphon-0.3.0" = "sha256-JGkNIfj1HjOF8kGxqJPNq/JO+NhZD6XrZ4KmkXEP6Xc=";
      "libc-0.2.151" = "sha256-VcNTcLOnVXMlX86yeY0VDfIfKOZyyx/DO1Hbe30BsaI=";
      "sctk-adwaita-0.5.4" = "sha256-yK0F2w/0nxyKrSiHZbx7+aPNY2vlFs7s8nu/COp2KqQ=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "smithay-client-toolkit-0.16.1" = "sha256-z7EZThbh7YmKzAACv181zaEZmWxTrMkFRzP0nfsHK6c=";
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
    libinput
    libglvnd
    fontconfig
    freetype
    xorg.libX11
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-term"
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

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/${pname}" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr
      ]} \
      --prefix PATH : ${lib.makeBinPath [ xwayland ]} \
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyabinary ];
    platforms = platforms.linux;
  };
}
