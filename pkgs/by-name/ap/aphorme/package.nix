{
  lib,
  fetchFromGitHub,
  rustPlatform,
  wayland,
  libxkbcommon,
  libGL,
  stdenv,
  testers,
  aphorme,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "aphorme";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "Iaphetes";
    repo = "aphorme_launcher";
    rev = "refs/tags/v${version}";
    hash = "sha256-p1ZIMMDyQWVzoeyHb3sbeV6XQwbIDoQwJU8ynI8hGUI=";
  };

  cargoHash = "sha256-aFoy5KTapx+5aIzvDwMfjxZQ6WKQtvX3h7rNX4LBeN8=";

  # No tests exist
  doCheck = false;

  buildInputs = [ stdenv.cc.cc.lib ];
  nativeBuildInputs = [ autoPatchelfHook ];

  runtimeDependencies = [
    wayland
    libGL
    libxkbcommon
  ];

  passthru.tests.version = testers.testVersion {
    package = aphorme;
    command = "aphorme --version";
    version = "aphorme ${version}";
  };

  meta = {
    description = "Program launcher for window managers, written in Rust";
    mainProgram = "aphorme";
    homepage = "https://github.com/Iaphetes/aphorme_launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ anytimetraveler ];
    platforms = lib.platforms.linux;
  };
}
