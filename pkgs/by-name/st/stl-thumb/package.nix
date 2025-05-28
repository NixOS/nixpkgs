{
  lib,
  fetchFromGitHub,
  libXcursor,
  libXrandr,
  libXi,
  rustPlatform,
  xorg,
  wayland,
  libGL,
  cmake,
  pkg-config,
  fontconfig,
}:

rustPlatform.buildRustPackage rec {
  pname = "stl-thumb";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "unlimitedbacon";
    repo = "stl-thumb";
    rev = "v${version}";
    sha256 = "sha256-sMgYrVQAtyVTfQyuTb/8OtRuDpagNQpt5YoF9lGIMHg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "glutin-0.28.0" = "sha256-8JkxpNyAy18ehwuS/Th/FE5/DyhecgpTW/va/xilm4w=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ fontconfig ];

  propagatedBuildInputs = [
    libXcursor
    libXrandr
    libXi
    wayland
    xorg.libX11
  ];

  doCheck = false;

  cargoHash = "sha256-qj1g8ecwB4VwrsUlSHRhIk8TMogNGgu6XbDVAgmtM98=";
  postInstall = ''
    mkdir $out/include
    cp libstl_thumb.h $out/include
    mkdir -p $out/thumbnailers
    mkdir -p $out/mime/packages
    cp stl-thumb.thumbnailer $out/thumbnailers/stl-thumb.thumbnailer
    cp stl-thumb-mime.xml $out/mime/packages/stl-thumb-mime.xml
  '';
  # libs are loaded dynamically; make sure we'll find them
  postFixup = ''
    patchelf \
    --add-needed ${lib.getLib xorg.libX11}/lib/libX11.so \
    --add-needed ${lib.getLib wayland}/lib/libwayland-client.so \
    --add-needed ${lib.getLib libGL}/lib/libEGL.so \
    $out/bin/stl-thumb
  '';

  meta = {
    description = "Thumbnail generator for STL files";
    homepage = "https://github.com/unlimitedbacon/stl-thumb";
    license = lib.licenses.mit;
    mainProgram = "stl-thumb";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ SyntaxualSugar ];
  };

}
