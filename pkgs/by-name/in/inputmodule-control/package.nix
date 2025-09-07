{
  lib,
  stdenv,
  testers,
  rustPlatform,
  fetchFromGitHub,
  inputmodule-control,
  pkg-config,
  libudev-zero,
  udevCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputmodule-control";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "inputmodule-rs";
    rev = "v${version}";
    hash = "sha256-5sqTkaGqmKDDH7byDZ84rzB3FTu9AKsWxA6EIvUrLCU=";
  };

  cargoHash = "sha256-s5k23p0Fo+DQvGpDvy/VmGNFK7ZysqLIyDPuUn6n724=";

  buildAndTestSubdir = "inputmodule-control";

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ libudev-zero ];

  doInstallCheck = true;

  postInstall = ''
    install -Dm644 release/50-framework-inputmodule.rules $out/etc/udev/rules.d/50-framework-inputmodule.rules
  '';

  passthru.tests.version = testers.testVersion {
    package = inputmodule-control;
  };

  meta = {
    description = "CLI tool to control Framework input modules like the LED matrix";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "inputmodule-control";
    homepage = "https://github.com/FrameworkComputer/inputmodule-rs";
    downloadPage = "https://github.com/FrameworkComputer/inputmodule-rs/releases/tag/${src.rev}";
    changelog = "https://github.com/FrameworkComputer/inputmodule-rs/releases/tag/${src.rev}";
    maintainers = with lib.maintainers; [ Kitt3120 ];
  };
}
