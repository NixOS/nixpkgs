{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, perl
, fontconfig
, copyDesktopItems
, makeDesktopItem
, glib
, gtk3
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
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jH473FdBI3rGt90L3WwMDPP8M3w0rtG5D758ceCMw94=";
  };

  cargoSha256 = "sha256-0Kya2KcyBDlt0TpFV60VAA3+JPfwId/+k8k+H97EhB0=";

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    copyDesktopItems
  ];

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    glib
    gtk3
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
    Security
    CoreServices
    ApplicationServices
    Carbon
    AppKit
  ];

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
