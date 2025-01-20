{
  lib,
  stdenv,
  cairo,
  fetchFromGitHub,
  fetchpatch,
  gdk-pixbuf,
  libxcrypt,
  libxkbcommon,
  meson,
  ninja,
  nix-update-script,
  pam,
  pkg-config,
  scdoc,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swaylock-plugin";
  version = "1.8.0";
  src = fetchFromGitHub {
    owner = "mstoeckl";
    repo = "swaylock-plugin";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Kd6Gqs+YnQu3qKfEeqW5CG38bU2gH2hqjoFEojWa8a4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    cairo
    libxcrypt
    gdk-pixbuf
    libxkbcommon
    pam
    wayland
    wayland-protocols
  ];

  patches = [
    # To remove for release > 1.8.0
    (fetchpatch {
      url = "https://github.com/mstoeckl/swaylock-plugin/commit/337a6a31dc354426ebf32e31ded56a7e5d350c7a.patch";
      hash = "sha256-r1BSubdnd0HzXvNDJm1qhdEltL27dHjPR1WlxaraHlc=";
    })
  ];

  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screen locker for Wayland, forked from swaylock";
    longDescription = ''
      swaylock-pulgins is a fork of swaylock, a screen locking utility for Wayland compositors.
      On top of the usual swaylock features, it allow you to use a
      subcommand to generate the lockscreen background.

      Important note: You need to set "security.pam.services.swaylock-plugin = {};" manually.
    '';
    homepage = "https://github.com/mstoeckl/swaylock-plugin";
    mainProgram = "swaylock-plugin";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ picnoir ];
  };
})
