{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-scanner,
  vali,
  libscfg,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kanshi";
  version = "1.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "kanshi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F6wyNFygU3uPBliDPOp5EdTeCx/5ZulnC9MOqYtiVQw=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libscfg
    vali
  ];

  meta = {
    description = "Dynamic display configuration tool";
    longDescription = ''
      kanshi allows you to define output profiles that are automatically enabled
      and disabled on hotplug. For instance, this can be used to turn a laptop's
      internal screen off when docked.

      kanshi can be used on Wayland compositors supporting the
      wlr-output-management protocol.
    '';
    homepage = "https://gitlab.freedesktop.org/emersion/kanshi";
    changelog = "https://gitlab.freedesktop.org/emersion/kanshi/-/tags/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "kanshi";
    maintainers = with lib.maintainers; [
      balsoft
      danielbarter
      aleksana
    ];
    platforms = lib.platforms.linux;
  };
})
