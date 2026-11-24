{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "midicomp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "markc";
    repo = "midicomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qhv66H03SS4dHQ+uAYjAZ4pUItWYuTfSK8LLjcaXvsk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert SMF MIDI files to and from plain text";
    homepage = "https://github.com/markc/midicomp";
    changelog = "https://github.com/markc/midicomp/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "midicomp";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
