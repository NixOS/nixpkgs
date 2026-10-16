{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arwen";
  version = "0.0.5-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "nichmor";
    repo = "arwen";
    rev = "696351a8c208315b0dfd4a1e5c37288a689ccd2e";
    hash = "sha256-6RW8BeKjoxeO8SBz/VdZGnrRW+EIKq5NtrFdM0lx0+o=";
  };

  cargoHash = "sha256-bj7YB7xNlfdrYYZv3CDuqkm+/pg+C1KwizPTlNqQWt8=";

  __structuredAttrs = true;

  meta = {
    description = "Cross-platform patching of shared libraries in Rust";
    longDescription = ''
      Arwen is a command-line utility and Rust library designed to modify
      executable files and shared libraries.

      Specifically, it targets the ELF format (commonly used on Linux, BSD, and
      other Unix-like systems) and the Mach-O format (used on macOS and iOS).

      It allows you to inspect and rewrite various properties within these
      files that influence how they load and link with other libraries at
      runtime.

      Think of arwen as a modern, unified, Rust-based alternative to the
      widely-used patchelf (for ELF files) and install_name_tool (for Mach-O
      files). It combines the core functionalities of both into a single tool.
    '';
    homepage = "https://github.com/nichmor/arwen";
    mainProgram = "arwen";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
