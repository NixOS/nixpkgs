{
  lib,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  cmake,
  pkgconf,
  freetype,
  expat,
  wayland,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libxkbcommon,
  pop-launcher,
  vulkan-loader,
  libGL,
}:

rustPlatform.buildRustPackage {
  pname = "onagre";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "onagre-launcher";
    repo = "onagre";
    rev = "1.1.1";
    hash = "sha256-yVkK3B7/ul0sOxPE3z2qkY/CnsZPQYqTpd64Wo/GXZI=";
  };

  cargoHash = "sha256-JsTBzkznFYiSOq41aptNa5akXTdkqJj3FwoHuvUlgpE=";

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkgconf
  ];
  buildInputs = [
    expat
    freetype
    libx11
    libxcursor
    libxi
    libxrandr
  ];

  postFixup =
    let
      rpath = lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        libxkbcommon
      ];
    in
    ''
      patchelf --set-rpath ${rpath} $out/bin/onagre
      wrapProgram $out/bin/onagre \
        --prefix PATH ':' ${
          lib.makeBinPath [
            pop-launcher
          ]
        }
    '';

  meta = {
    description = "General purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
    homepage = "https://github.com/onagre-launcher/onagre";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.jfvillablanca
      lib.maintainers.ilya-epifanov
    ];
    platforms = lib.platforms.linux;
    mainProgram = "onagre";
  };
}
