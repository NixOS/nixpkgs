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

rustPlatform.buildRustPackage rec {
  pname = "onagre";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "onagre-launcher";
    repo = "onagre";
    rev = "1.1.0";
    hash = "sha256-ASeLvgj2RyhsZQtkUTYeA7jWyhbLg8yl6HbN2A/Sl2M=";
  };

  cargoHash = "sha256-17Hw3jtisOXwARpp0jB0hrNax7nzMWS0kCE3ZAruBj8=";

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
    description = "A general purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
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
