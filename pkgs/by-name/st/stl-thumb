{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXcursor,
  libXrandr,
  libXi
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "stl-thumb";
  version = "v0.5.0-6bc9057";

  src = fetchFromGitHub {
    owner = "unlimitedbacon";
    repo = pname;
    rev = "6bc90573b2cddda3f8916b2716898298475406c0";
    sha256 = "sha256-G5zk1FR18rhWdC1S1cGOcsAHRpq03A7+ivNs4sUpl54=";
  };

  doCheck = false;

  cargoHash = "sha256-eSQsNX23fjFNZtVkmbWZmZgYOnbR0BsL+hwzQVEbBS4=";
  postInstall = ''
    mkdir $out/include
    cp libstl_thumb.h $out/include
    mkdir -p $out/thumbnailers
    mkdir -p $out/mime/packages
    cp stl-thumb.thumbnailer $out/thumbnailers/stl-thumb.thumbnailer
    cp stl-thumb-mime.xml $out/mime/packages/stl-thumb-mime.xml
  '';
  # libs are loaded dynamically; make sure we'll find them
  postFixup = with pkgs; ''
    patchelf \
    --add-needed ${xorg.libX11}/lib/libX11.so \
    --add-needed ${wayland}/lib/libwayland-client.so \
    --add-needed ${libGL}/lib/libEGL.so \
    $out/bin/stl-thumb
  '';
  meta = with lib; {
    description = "Thumbnail generator for STL files";
    homepage = "https://github.com/unlimitedbacon/stl-thumb";
    license = licenses.mit;
    maintainers = [ SyntaxualSugar ];
  };
  buildInputs = with pkgs; [
    fontconfig
    libX11
  ];
  propagatedBuildInputs = [
    libXcursor
    libXrandr
    libXi
  ];
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
}
