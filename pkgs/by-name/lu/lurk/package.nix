{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lurk";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = "lurk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sng+mMMKDuI1aSgusJDRFMT5iKNUlp9arp9ruRn0bb0=";
  };

  cargoHash = "sha256-Cmlhhda35FmNg/OvfMRPHBLPRXF5bs0ebBYT7KfierA=";

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail '/usr/bin/ls' 'ls'
  '';

  meta = {
    changelog = "https://github.com/jakwai01/lurk/releases/tag/v${finalAttrs.version}";
    description = "Simple and pretty alternative to strace";
    homepage = "https://github.com/jakwai01/lurk";
    license = lib.licenses.agpl3Only;
    mainProgram = "lurk";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
