{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  perl,
  makeWrapper,
  stdenv,
  wayland,
  libxkbcommon,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "mostrix";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MostroP2P";
    repo = "mostrix";
    tag = "v${version}";
    hash = "sha256-zKzPP+GRVLAon1ULDWOhcDjM/E4VAIsmnDethCoyL/w=";
  };

  cargoHash = "sha256-9mcSTB4guSrniQH0N9B+0//lpjLRoUWbaw22NZ9ps2U=";

  patches = [
    # write app.log to ~/.mostrix instead of read-only nix store
    ./log-to-home-dir.patch
  ];

  nativeBuildInputs = [
    pkg-config
    # aws-lc-sys (pulled in transitively via rustls/nostr-sdk) builds its
    # vendored C sources with cmake, and uses perl for the asm generators.
    cmake
    perl
    makeWrapper
  ];

  # sqlite (via libsqlite3-sys "bundled") is compiled from vendored C sources,
  # so no system sqlite is required at build time.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libxkbcommon
    libxcb
  ];

  # Some tests initialize the SQLite database under $HOME/.mostrix, which is
  # unwritable in the build sandbox.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # TODO: add versionCheckHook once upstream has a --version flag.

  # arboard dlopens the Wayland/X11 clipboard backends at runtime; make the
  # libraries discoverable so copy/paste works outside a dev shell.
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/mostrix \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  '';

  meta = {
    description = "Mostro TUI client for peer-to-peer Bitcoin trading over Nostr";
    homepage = "https://github.com/MostroP2P/mostrix";
    changelog = "https://github.com/MostroP2P/mostrix/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ekzyis ];
    mainProgram = "mostrix";
    platforms = lib.platforms.unix;
  };
}
