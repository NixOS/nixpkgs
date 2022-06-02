{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, python3
, perl
, freetype
, fontconfig
, libxkbcommon
, xcbutil
, libX11
, libXcursor
, libXrandr
, libXi
, vulkan-loader
, copyDesktopItems
, makeDesktopItem
, openssl
, libobjc
, Security
, CoreServices
, ApplicationServices
, Carbon
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KSumy7M7VNUib4CZ0ikBboEFMzDQt4xW+aUFHOi+0pA=";
  };

  cargoSha256 = "sha256-7SVTcH9/Ilq8HcpJJI0KFiQA076lR2CAIBwmTVgmnjE=";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    perl
    copyDesktopItems
  ];

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    freetype
    fontconfig
    libxkbcommon
    xcbutil
    libX11
    libXcursor
    libXrandr
    libXi
    vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
    Security
    CoreServices
    ApplicationServices
    Carbon
    AppKit
  ];

  # Add missing vulkan dependency to rpath
  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf --add-needed ${vulkan-loader}/lib/libvulkan.so.1 $out/bin/lapce
  '';

  postInstall = ''
    install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/lapce.svg
  '';

  desktopItems = [ (makeDesktopItem {
    name = "lapce";
    exec = "lapce %F";
    icon = "lapce";
    desktopName = "Lapce";
    comment = meta.description;
    genericName = "Code Editor";
    categories = [ "Development" "Utility" "TextEditor" ];
  }) ];

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ elliot ];
  };
}
