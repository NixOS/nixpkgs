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
  version = "0.6.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ifreund";
    repo = "waylock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RSAUSlsBB9IphvdSiFqJIvyhhJoAKKb+KyGhdoTa3vs=";
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

  meta = {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ adamcstephens jordanisaacs ];
    mainProgram = "waylock";
    platforms = lib.platforms.linux;
  };
})
