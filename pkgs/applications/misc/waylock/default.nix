{ lib
, stdenv
, fetchFromGitea
, libxkbcommon
, pam
, pkg-config
, scdoc
, wayland
, wayland-protocols
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylock";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ifreund";
    repo = "waylock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Z5YNaR+jocJ4hS7NT8oAlrMnqNfD8KRzOyyqdVGDSl0=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland
    zig_0_11.hook
  ];

  buildInputs = [
    wayland-protocols
    libxkbcommon
    pam
  ];

  zigBuildFlags = [ "-Dman-pages" ];

  passthru.updateScript = ./update.nu;

  meta = {
    homepage = "https://codeberg.org/ifreund/waylock";
    changelog = "https://codeberg.org/ifreund/waylock/releases/tag/v${finalAttrs.version}";
    description = "A small screenlocker for Wayland compositors";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ adamcstephens jordanisaacs ];
    mainProgram = "waylock";
    platforms = lib.platforms.linux;
  };
})
