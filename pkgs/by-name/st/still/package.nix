{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  pixman,
  wayland-scanner,
  nix-update-script,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "still";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "faergeek";
    repo = "still";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AGArWr/T8VMZpEVbr/SIvERGTOAgoREH+68PSL6k6yg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    pixman
    wayland
    wayland-protocols
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postInstall = ''
    install -Dm644 $src/LICENSE $out/share/licenses/still/LICENSE
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Freeze the screen of a Wayland compositor until a provided command exits";
    homepage = "https://github.com/faergeek/still";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "still";
    maintainers = [ lib.maintainers.fazzi ];
  };
})
