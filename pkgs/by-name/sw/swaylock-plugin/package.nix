{
  cairo,
  fetchFromGitHub,
  gdk-pixbuf,
  lib,
  libxcrypt,
  libxkbcommon,
  makeWrapper,
  meson,
  ninja,
  nix-update-script,
  pam,
  pkg-config,
  scdoc,
  stdenv,
  swaybg,
  systemd,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "swaylock-plugin";
  version = "unstable-2025-01-28";
  src = fetchFromGitHub {
    owner = "mstoeckl";
    repo = "swaylock-plugin";
    rev = "ac02c528bce8f529f33c85065d77eac1aceccbe5";
    hash = "sha256-e4iQ7yCPkkJBpgD0aE94lsID8v3kXhr7YmAszfFi7zA=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  nativeBuildInputs = [
    makeWrapper
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
    systemd
    wayland
    wayland-protocols
  ];

  postInstall = ''
    wrapProgram $out/bin/swaylock-plugin \
      --prefix PATH : "${lib.makeBinPath [ swaybg ]}"
  '';

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
}
