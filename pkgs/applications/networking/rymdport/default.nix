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
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "3.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Jacalz";
    repo = "rymdport";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nqB4KZdYSTiyIaslFN6ncwJnD8+7ZgHj/SXAa5YAt9k=";
  };

  vendorHash = "sha256-03qdjeU6u0mBcdWlMhs9ORaeBkPNMO4Auqy/rOFIaVM=";
=======
    hash = "sha256-dwIfkslbqphLQrmDNeukDhLskH1bBGG65Ve9LQzNeJg=";
  };

  vendorHash = "sha256-Q3bUH1EhY63QF646FYwiVXusWPTqI5Am2AVJq+qyNVo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
