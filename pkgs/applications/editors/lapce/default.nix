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
}:

rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "v${version}";
    sha256 = "tOVFm4DFQurFU4DtpPwxXQLbTGCZnrV1FfYKtvkRxRE=";
  };

  cargoPatches = [ ./fix-version.patch ];

  cargoSha256 = "BwB3KgmI5XnZ5uHv6f+kGKBzpyxPWcoKvF7qw90eorI=";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    perl
    copyDesktopItems
  ];

  buildInputs = [
    freetype
    fontconfig
    libxkbcommon
    xcbutil
    libX11
    libXcursor
    libXrandr
    libXi
    vulkan-loader
  ];

  # Add missing vulkan dependency to rpath
  preFixup = ''
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
    broken = stdenv.isDarwin;
  };
}
