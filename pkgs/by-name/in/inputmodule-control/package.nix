{
  lib,
  stdenv,
  testers,
  rustPlatform,
  fetchFromGitHub,
  inputmodule-control,
  pkg-config,
  libudev-zero,
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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "st7306-0.8.2" = "sha256-YTFVedMnt+fMZ9zs/LaEpJ+w6qOWyLNg+6Afo2+Uzls=";
      "vis-core-0.1.0" = "sha256-Jw0UMBT/ddNzILAIEHwgcvqvuPDaJmjzoLUcTQMpWe8=";
    };
  };

  buildAndTestSubdir = "inputmodule-control";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libudev-zero ];

  postInstall = ''
    install -Dm644 release/50-framework-inputmodule.rules $out/etc/udev/rules.d/50-framework-inputmodule.rules
  '';

  passthru.tests.version = testers.testVersion {
    package = inputmodule-control;
    command = "${meta.mainProgram} --version";
    version = "${meta.mainProgram} ${version}";
  };

  meta = with lib; {
    description = "CLI tool to control Framework input modules like the LED matrix";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "inputmodule-control";
    homepage = "https://github.com/FrameworkComputer/inputmodule-rs";
    downloadPage = "https://github.com/FrameworkComputer/inputmodule-rs/releases/tag/${src.rev}";
    changelog = "https://github.com/FrameworkComputer/inputmodule-rs/releases/tag/${src.rev}";
    maintainers = with maintainers; [ Kitt3120 ];
  };
}
