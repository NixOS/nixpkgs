{
  lib,
  rustPlatform,
  fetchpatch,
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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "rerun-io";
    repo = "rerun";
    rev = version;
    hash = "sha256-HgzzuvCpzKgWC8it0PSq62hBjjqpdgYtQQ50SNbr3do=";
  };
  patches = [
    # Disables a doctest that depends on a nightly feature
    ./0001-re_space_view_time_series-utils-patch-out-doctests-w.patch

    # "Fix cell size test now that the overhead has shrunk"
    # https://github.com/rerun-io/rerun/pull/5917
    (fetchpatch {
      url = "https://github.com/rerun-io/rerun/commit/933fc5cc1f3ee262a78bd4647257295747671152.patch";
      hash = "sha256-jCeGfzKt0oYqIea+7bA2V/U9VIjhVvfQzLRrYG4jaHY=";
    })
  ];

  cargoHash = "sha256-qvnkOlcjADV4b+JfFAy9yNaZGaf0ZO7hh9HBg5XmPi0=";

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
    ++ lib.optionals stdenv.isDarwin [
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
    ++ lib.optionals stdenv.isLinux [ (lib.getLib wayland) ];

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

  cargoTestFlags = [
    "-p"
    "rerun"
    "--workspace"
    "--exclude=crates/rerun/src/lib.rs"
  ];

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
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "rerun";
  };
}
