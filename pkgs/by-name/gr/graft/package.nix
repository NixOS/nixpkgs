{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  ffmpeg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "graft";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "eonik-ai";
    repo = "graft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fM5UA1SOV8UF26SFEa3M01A36GmRoUQYsLHNxlq9xUo=";
  };

  cargoLock.lockFile = ./Cargo.lock;
  cargoBuildFlags = [ "--bin" "graft" ];
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/graft \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    description = "Local-first composition workspace with an incremental video compiler";
    homepage = "https://github.com/eonik-ai/graft";
    changelog = "https://github.com/eonik-ai/graft/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "graft";
  };
})
