{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, libsecret
, libxkbcommon
, openssl
, pango
, sqlite
, vulkan-loader
, stdenv
, darwin
, wayland
}:

let
  commitDate = "2024-04-30";
in rustPlatform.buildRustPackage rec {
  pname = "cosmic-tasks";
  version = "0-unstable-${commitDate}";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = "cosmic-tasks";
    rev = "020ae8633b23091f113b19f4b6f992e36404f2e2";
    hash = "sha256-ZPEzvscLYH4vJ+5Nh5J9m8ZX2jXXDMOLswSnHaCdSdA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-KVcKQ4DtoZCgFBnejIaQfQxJJJxd/mFzHBI+4PbGBio=";
      "cosmic-config-0.1.0" = "sha256-VEE/1XQZaojz9gxTV/Zz++eVplsCfiDPgf/cAr2Rih8=";
      "cosmic-text-0.11.2" = "sha256-gUIQFHPaFTmtUfgpVvsGTnw2UKIBx9gl0K67KPuynWs=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-LDd56TJ175qsj2/EV/dbBRV9HMU7RzgrG5JP7H2PmhE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = commitDate;
  env.VERGEN_GIT_SHA = src.rev;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsecret
    libxkbcommon
    openssl
    pango
    sqlite
    vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Metal
    darwin.apple_sdk.frameworks.QuartzCore
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/cosmic-tasks \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libxkbcommon wayland ]}"
  '';

  meta = with lib; {
    description = "A simple task management application for the COSMIC desktop";
    homepage = "https://github.com/edfloreshz/cosmic-tasks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
    mainProgram = "cosmic-tasks";
  };
}
