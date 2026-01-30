{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  libGL,
  libxkbcommon,
  pipewire,
  wayland,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-viz";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ax9d";
    repo = "pw-viz";
    rev = "v${version}";
    sha256 = "sha256-fB7PnWWahCMKhGREg6neLmOZjh2OWLu61Vpmfsl03wA=";
  };

  cargoHash = "sha256-jsaWrdJRKfu75Gw8qGHxx0FHK7rOEK8IEDiQ6ktZsM0=";

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
    libx11
    libxcursor
    libxi
    libxrandr
  ];

  postFixup = ''
    patchelf $out/bin/pw-viz \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  # enables pipewire API deprecated in 0.3.64
  # fixes error caused by https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  env.NIX_CFLAGS_COMPILE = toString [ "-DPW_ENABLE_DEPRECATED" ];

  meta = {
    description = "Simple and elegant pipewire graph editor";
    homepage = "https://github.com/ax9d/pw-viz";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
