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
  xorg,
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
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
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

  meta = with lib; {
    description = "General purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
    homepage = "https://github.com/onagre-launcher/onagre";
    license = licenses.mit;
    maintainers = [
      maintainers.jfvillablanca
      maintainers.ilya-epifanov
    ];
    platforms = platforms.linux;
    mainProgram = "onagre";
  };
}
