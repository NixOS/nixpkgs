{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pfetch";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "Un1q32";
    repo = "pfetch";
    tag = version;
    hash = "sha256-lzXoe4RYfd8aSnrkpz5VYhMlJUcaMsZBZyPBOjpBXG8=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin pfetch
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Pretty system information tool written in POSIX sh";
    homepage = "https://github.com/Un1q32/pfetch";
    changelog = "https://github.com/Un1q32/pfetch/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      equirosa
      phanirithvij
    ];
    mainProgram = "pfetch";
  };
}
