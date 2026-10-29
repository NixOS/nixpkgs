{
  lib,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  stdenv,
  swift,
  swiftpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-apple-macros";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "xtool-org";
    repo = "OpenAppleMacros";
    tag = "v1.3.0";
    hash = "sha256-qZQ3SH97bS/diA2gHOuVBlLgpNAeDW1IwebJLl2nN3M=";
  };

  strictDeps = true;

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-rjwdYAYV5j7yYXtyLFhaXkqyl0sKj50FA1XoHcgm9qo=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  postInstall =
    # Put the plugin server at the expected location.
    ''
      declare -a supportedPlugins=(
        FoundationModels
        SwiftUI
      )

      mkdir -p "$out/libexec/swift"
      mv "$out/bin" "$out/libexec/swift/plugins"

      # Use stub libraries so that users need only specify the plugin path and plugin server.
      mkdir -p "$out/lib/swift/host/plugins"
      for plugin in "''${supportedPlugins[@]}"; do
        touch "$out/lib/swift/host/plugins/lib''${plugin}Macros${stdenv.hostPlatform.extensions.sharedLibrary}"
      done
    '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/xtool-org/OpenAppleMacros";
    description = "Open source reimplementation of Xcode-only Swift macros";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.mit;
    teams = [ lib.teams.swift ];
  };
})
