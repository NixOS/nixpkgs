{ lib
, stdenv
, darwin
, fetchFromGitHub
, libxkbcommon
, openssl
, pkg-config
, rustPlatform
, vulkan-loader
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "halloy";
  version = "23.1-alpha1";

  src = fetchFromGitHub {
    owner = "squidowl";
    repo = "halloy";
    rev = "refs/tags/${version}";
    hash = "sha256-Aq+mKctmc1RwpnUEIi+Zmr4o8n6wgQchGCunPWouLsE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-text-0.8.0" = "sha256-p8PtXcFH+T3z6wWPFYbHFkxrkJpK4oHJ1aJvq4zld/4=";
      "glyphon-0.2.0" = "sha256-7h5W82zPMw9PVZiF5HCo7HyRiVhGR8MsfgGuIjo+Kfg=";
      "iced-0.9.0" = "sha256-KEBm62lDjSKXvXZssLoBfUYDSW+OpTXutxsKZMz8SE0=";
      "irc-0.15.0" = "sha256-ZlwfyX4tmQr9D+blY4jWl85bwJ2tXUYp3ryLqoungII=";
      "winit-0.28.6" = "sha256-szB1LCOPmPqhZNIWbeO8JMfRMcMRr0+Ze0f4uqyR8AE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    openssl
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Metal
    darwin.apple_sdk.frameworks.QuartzCore
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  meta = with lib; {
    description = "IRC application";
    homepage = "https://github.com/squidowl/halloy";
    changelog = "https://github.com/squidowl/halloy/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
