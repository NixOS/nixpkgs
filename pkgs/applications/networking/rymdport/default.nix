{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, libGL
, xorg
, Carbon
, Cocoa
}:

buildGoModule rec {
  pname = "rymdport";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "Jacalz";
    repo = "rymdport";
    rev = "v${version}";
    hash = "sha256-8Iul8YSxrfP7uG/uSmV+Qro+B1r+mhkOxCICHf204Lg=";
  };

  vendorHash = "sha256-9Z++E4Lb1+VBvOx5GJ4yQuj7fpwUhlsMhavTifKxVw4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = with xorg; [
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXxf86vm
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    Cocoa
    IOKit
  ];

  meta = {
    description = "Easy encrypted file, folder, and text sharing between devices";
    homepage = "https://github.com/Jacalz/rymdport";
    changelog = "https://github.com/Jacalz/rymdport/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
