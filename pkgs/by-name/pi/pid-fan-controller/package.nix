{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.1.3";
in
rustPlatform.buildRustPackage {
  pname = "pid-fan-controller";
  inherit version;

  src = fetchFromGitHub {
    owner = "zimward";
    repo = "pid-fan-controller";
    tag = version;
    hash = "sha256-BgBFX4x1gMSMla7lhkFk1n5fBC1TFK0Z5Z3mFH2oBF0=";
  };
  cargoHash = "sha256-AN7EbjKZBxb8UP0MEbJUw5Y8E/rE35MByKVmxX2ctko=";

  postPatch = ''
    substituteInPlace resources/pid-fan-controller.service \
      --replace-fail '/usr/bin' "$out/bin"
  '';
  postInstall = ''
    install -Dm0644 resources/pid-fan-controller.service $out/lib/systemd/system/pid-fan-controller.service
    install -Dm0644 resources/pid-fan-controller-sleep.service $out/lib/systemd/system/pid-fan-controller-sleep.service
  '';

  meta = {
    description = "Service to provide closed-loop PID fan control";
    homepage = "https://github.com/zimward/pid-fan-controller";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zimward ];
    platforms = lib.platforms.linux;
    mainProgram = "pid-fan-controller";
  };
}
