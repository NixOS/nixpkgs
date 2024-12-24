{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, expat
, fontconfig
, freetype
, libGL
, libxkbcommon
, pipewire
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-viz";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ax9d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fB7PnWWahCMKhGREg6neLmOZjh2OWLu61Vpmfsl03wA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egui_nodes-0.1.4" = "sha256-Bb88T+erjgKD769eYOSiVEg9lFnB5pBEDLeWgCdyUus=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libGL
    libxkbcommon
    pipewire
    rustPlatform.bindgenHook
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  postFixup = ''
    patchelf $out/bin/pw-viz \
      --add-rpath ${lib.makeLibraryPath [ libGL libxkbcommon wayland ]}
  '';

  # enables pipewire API deprecated in 0.3.64
  # fixes error caused by https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  env.NIX_CFLAGS_COMPILE = toString [ "-DPW_ENABLE_DEPRECATED" ];

  meta = with lib; {
    description = "Simple and elegant pipewire graph editor";
    homepage = "https://github.com/ax9d/pw-viz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
