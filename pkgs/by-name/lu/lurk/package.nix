{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = "lurk";
    tag = "v${version}";
    hash = "sha256-5riwosaT7QjRFnIFRAcyLul7i1g8OpHyUuuJNOROTF0=";
  };

  cargoHash = "sha256-CDrqcKNhQYbtDaasyCQ6VPGdIrW34VBKPDpbFeommAc=";

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail '/usr/bin/ls' 'ls'
  '';

  meta = {
    changelog = "https://github.com/jakwai01/lurk/releases/tag/v${version}";
    description = "Simple and pretty alternative to strace";
    homepage = "https://github.com/jakwai01/lurk";
    license = lib.licenses.agpl3Only;
    mainProgram = "lurk";
    maintainers = with lib.maintainers; [
      figsoda
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
