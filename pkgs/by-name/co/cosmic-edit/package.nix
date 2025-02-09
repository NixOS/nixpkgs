{
  lib,
  stdenv,
  fetchFromGitHub,
  rust,
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
  version = "unstable-2023-11-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "4a3dd101f35eb3c1c585f104d78ed4ee31d393d3";
    hash = "sha256-pk+4u13oWZ4fgXy1tlDgq+E4J+UddjTNSexMm4dgBSo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-wBliqZbRHYiwZmu0vHeIP5DFzg/1IeQP3aMxiYC88bo=";
      "cosmic-text-0.10.0" = "sha256-fE5HkhITLw0OBfFLFMsKEJw5idO265i4S7qylHTt7C0=";
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

  nativeBuildInputs = [
    cmake
    just
    pkg-config
    makeBinaryWrapper
  ];
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
    "target/${
      rust.lib.toRustTargetSpecShort stdenv.hostPlatform
    }/release/cosmic-edit"
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
    maintainers = with maintainers; [ ahoneybun ];
    platforms = platforms.linux;
  };
}
