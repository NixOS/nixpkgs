{ lib
, rustPlatform
, clangStdenv
, fetchFromGitHub
, linkFarm
, fetchgit
, runCommand
, gn
, ninja
, makeWrapper
, pkg-config
, python3
, removeReferencesTo
, xcbuild
, SDL2
, fontconfig
, xorg
, stdenv
, darwin
, libglvnd
, libxkbcommon
, enableWayland ? stdenv.isLinux
, wayland
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "neovide";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "neovide";
    repo = "neovide";
    rev = version;
    sha256 = "sha256-0vIq8vJPvcmA7hRyGY4qQRxwmgQAKHVU+452iMohGCA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "glutin-0.26.0" = "sha256-Ie4Jb3wCMZSmF1MUzkLG2TqsLrXXzzi6ATjzCjevZBc=";
      "winit-0.24.0" = "sha256-p/eAaDVmTHzfZ+0DiBA/9v06Z5o1dXVNoCgWRqC1ed0=";
      "xkbcommon-dl-0.1.0" = "sha256-ojokJF7ivN8JpXo+JAfX3kUOeXneNek7pzIy8D1n4oU=";
    };
  };

  SKIA_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m103-0.51.1";
        sha256 = "sha256-w5dw/lGm40gKkHPR1ji/L82Oa808Kuh8qaCeiqBLkLw=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = linkFarm "skia-externals" (lib.mapAttrsToList
        (name: value: { inherit name; path = fetchgit value; })
        (lib.importJSON ./skia-externals.json));
    in
    runCommand "source" { } ''
      cp -R ${repo} $out
      chmod -R +w $out
      ln -s ${externals} $out/third_party/externals
    ''
  ;

  SKIA_GN_COMMAND = "${gn}/bin/gn";
  SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3 # skia
    removeReferencesTo
  ] ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  # All tests passes but at the end cargo prints for unknown reason:
  #   error: test failed, to rerun pass '--bin neovide'
  # Increasing the loglevel did not help. In a nix-shell environment
  # the failure do not occure.
  doCheck = false;

  buildInputs = [
    SDL2
    fontconfig
    rustPlatform.bindgenHook
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  postFixup = let
    libPath = lib.makeLibraryPath ([
      libglvnd
      libxkbcommon
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXi
    ] ++ lib.optionals enableWayland [ wayland ]);
  in ''
      # library skia embeds the path to its sources
      remove-references-to -t "$SKIA_SOURCE_DIR" \
        $out/bin/neovide

      wrapProgram $out/bin/neovide \
        --prefix LD_LIBRARY_PATH : ${libPath}
    '';

  postInstall = ''
    for n in 16x16 32x32 48x48 256x256; do
      install -m444 -D "assets/neovide-$n.png" \
        "$out/share/icons/hicolor/$n/apps/neovide.png"
    done
    install -m444 -Dt $out/share/icons/hicolor/scalable/apps assets/neovide.svg
    install -m444 -Dt $out/share/applications assets/neovide.desktop
  '';

  disallowedReferences = [ SKIA_SOURCE_DIR ];

  meta = with lib; {
    description = "This is a simple graphical user interface for Neovim.";
    homepage = "https://github.com/neovide/neovide";
    changelog = "https://github.com/neovide/neovide/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ck3d ];
  };
}
