{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, libGL
, pipewire
, freetype
, fontconfig
, xorg
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-viz";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ax9d";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lw4whdh8tNoS5XUlamQCq8f8z8K59uD90PSSo3skeyo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egui_nodes-0.1.4" = "sha256-Bb88T+erjgKD769eYOSiVEg9lFnB5pBEDLeWgCdyUus=";
    };
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    libGL
    freetype
    fontconfig
    pipewire
    rustPlatform.bindgenHook
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libxcb
    libxkbcommon
    wayland
  ];

  postFixup = ''
    patchelf $out/bin/pw-viz --add-rpath ${lib.makeLibraryPath [
      libGL xorg.libXrandr wayland
      libxkbcommon
    ]}
  '';

  # enables pipewire API deprecated in 0.3.64
  # fixes error caused by https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  env.NIX_CFLAGS_COMPILE = toString [ "-DPW_ENABLE_DEPRECATED" ];

  meta = with lib; {
    description = "A simple and elegant pipewire graph editor ";
    homepage = "https://github.com/ax9d/pw-viz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
