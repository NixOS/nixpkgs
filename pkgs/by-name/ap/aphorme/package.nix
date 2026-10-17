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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aphorme";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Iaphetes";
    repo = "aphorme_launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSJlWInGMFnn+16um7j8Dp92LYdNsfAdLJQSQIDAlaA=";
  };

  cargoHash = "sha256-CRDVIY5HVMFme+fOf9tdoT+VVy5z2+s5opw/KH25YOw=";

  # No tests exist
  doCheck = false;

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];
  nativeBuildInputs = [ autoPatchelfHook ];

  runtimeDependencies = [
    wayland
    libGL
    libxkbcommon
  ];

  passthru.tests.version = testers.testVersion {
    package = aphorme;
    command = "aphorme --version";
    version = "aphorme ${finalAttrs.version}";
  };

  meta = {
    description = "Program launcher for window managers, written in Rust";
    mainProgram = "aphorme";
    homepage = "https://github.com/Iaphetes/aphorme_launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ anytimetraveler ];
    platforms = lib.platforms.linux;
  };
})
