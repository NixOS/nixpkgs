{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  libxkbfile,
  libx11,
  libxext,
  libxmu,
  libxt,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oclock";
  version = "1.0.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "oclock";
    tag = "oclock-${finalAttrs.version}";
    hash = "sha256-rk+PV2iEoqRwXN8bq0kCPk0qW0VPwid1T1XrH+Y9yLw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
  ];

  buildInputs = [
    libxkbfile
    libx11
    libxext
    libxmu
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=oclock-(.*)" ]; };

  meta = {
    description = "simple analog clock using the X11 SHAPE extension to make a round window";
    homepage = "https://gitlab.freedesktop.org/xorg/app/oclock";
    license = with lib.licenses; [
      mitOpenGroup
      x11
    ];
    mainProgram = "oclock";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
