{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  binaryen,
  rustfmt,
  lld,
  darwin,
  freetype,
  glib,
  gtk3,
  libxkbcommon,
  openssl,
  protobuf,
  vulkan-loader,
  wayland,
  python3Packages,
}:

rustPlatform.buildRustPackage rec {
  pname = "rerun";
  version = "0.20.2";
  src = fetchFromGitHub {
    owner = "rerun-io";
    repo = "rerun";
    rev = "refs/tags/${version}";
    hash = "sha256-AoI+BKDqHRsBrZAAwrE17xCduIP9wI7WPSSpn7SMz/M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LB8P9ceHN4zq+8qv1h0nDKW9FVTEbSrX/Zbv2WB29ck=";

  cargoBuildFlags = [ "--package rerun-cli" ];
  cargoTestFlags = [ "--package rerun-cli" ];
  buildNoDefaultFeatures = true;
  buildFeatures = [ "native_viewer" ];

  nativeBuildInputs = [
    (lib.getBin binaryen) # wasm-opt

    # @SomeoneSerge: Upstream suggests `mold`, but I didn't get it to work
    lld

    pkg-config
    protobuf
    rustfmt
  ];

  buildInputs =
    [
      freetype
      glib
      gtk3
      (lib.getDev openssl)
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Metal
      darwin.apple_sdk.frameworks.QuartzCore
      darwin.apple_sdk.frameworks.Security
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib wayland) ];

  addDlopenRunpaths = map (p: "${lib.getLib p}/lib") (
    lib.optionals stdenv.hostPlatform.isLinux [
      libxkbcommon
      vulkan-loader
      wayland
    ]
  );

  addDlopenRunpathsPhase = ''
    elfHasDynamicSection() {
        patchelf --print-rpath "$1" >& /dev/null
    }

    while IFS= read -r -d $'\0' path ; do
      elfHasDynamicSection "$path" || continue
      for dep in $addDlopenRunpaths ; do
        patchelf "$path" --add-rpath "$dep"
      done
    done < <(
      for o in $(getAllOutputNames) ; do
        find "''${!o}" -type f -and "(" -executable -or -iname '*.so' ")" -print0
      done
    )
  '';

  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  # The path in `build.rs` is wrong for some reason, so we patch it to make the passthru tests work
  patches = [ ./tests.patch ];
  passthru.tests = {
    inherit (python3Packages) rerun-sdk;
  };

  meta = with lib; {
    description = "Visualize streams of multimodal data. Fast, easy to use, and simple to integrate.  Built in Rust using egui";
    homepage = "https://github.com/rerun-io/rerun";
    changelog = "https://github.com/rerun-io/rerun/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      SomeoneSerge
      robwalt
    ];
    mainProgram = "rerun";
  };
}
