{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  dbus,
  pkg-config,
  libx11,
  libxext,
  libxft,
  libxinerama,
  libxcursor,
  libxrender,
  libxfixes,
  cairo,
  pango,
  fontconfig,
  freetype,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  libdecor,
  sysprof,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "piki";
  version = "0.7.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "piki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EAJl0cnwP8h8GG1XTefm5H3fGrELlZaTWAwWjzQUtOE=";
  };

  cargoHash = "sha256-4fJNbx37f+3DHoyfzAjmxdl46m+fFxJh2M4H4x5eXhw=";

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wayland-scanner
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cairo
    dbus
    pango
    fontconfig
    freetype

    wayland
    wayland-protocols
    libxkbcommon
    libdecor

    libx11
    libxext
    libxft
    libxinerama
    libxcursor
    libxrender
    libxfixes
    sysprof
  ];

  # These integration tests require localhost TCP sockets,
  # which are unavailable in nix sandbox
  checkFlags = [
    "--skip=rejects_path_traversal"
    "--skip=serves_current_note_with_rewritten_links_and_reload_script"
    "--skip=root_redirects_to_current_note"
    "--skip=serves_other_notes_from_disk_and_404s_unknown"
    "--skip=version_endpoint_tracks_live_updates"
    "--skip=selection_highlight_is_served_and_cleared"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple personal wiki";
    homepage = "https://github.com/roblillack/piki";
    changelog = "https://github.com/roblillack/piki/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pixelcmnd ];
    mainProgram = "piki";
  };
})
