{
  lib,
  stdenv,
  fetchFromGitHub,

  meson,
  ninja,
  pkg-config,

  gettext,
  libnl,
  libtraceevent,
  libtracefs,
  ncurses,
  pciutils,

  testers,
  nix-update-script,
  powertop,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powertop";
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = "powertop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s60ToU99Oercf56icoowjS4L2FRFmB+KN7i3pEmsw4w=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gettext
    libnl
    libtraceevent
    libtracefs
    ncurses
    pciutils
  ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace-fail "/sbin/modprobe" "modprobe"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = powertop;
      command = "powertop --version";
      inherit (finalAttrs) version;
    };
  };

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    changelog = "https://github.com/fenrus75/powertop/releases/tag/v${finalAttrs.version}";
    description = "Analyze power consumption on Intel-based laptops";
    mainProgram = "powertop";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      fpletz
      anthonyroussel
    ];
    platforms = lib.platforms.linux;
  };
})
