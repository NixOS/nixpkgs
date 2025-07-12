{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  coreutils,
  gnused,
  jq,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bash-env-json";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "tesujimath";
    repo = "bash-env-json";
    rev = finalAttrs.version;
    hash = "sha256-gyqj5r11DOfXd23LT7qwRLEoWvpHUbxbd28QJnlWTaQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 bash-env-json -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/bin/bash-env-json --replace-fail " env " " ${lib.getExe' coreutils "env"} "
    substituteInPlace $out/bin/bash-env-json --replace-fail " jq " " ${lib.getExe jq} "
    substituteInPlace $out/bin/bash-env-json --replace-fail " mktemp " " ${lib.getExe' coreutils "mktemp"} "
    substituteInPlace $out/bin/bash-env-json --replace-fail " rm " " ${lib.getExe' coreutils "rm"} "
    substituteInPlace $out/bin/bash-env-json --replace-fail " sed " " ${lib.getExe gnused} "
    substituteInPlace $out/bin/bash-env-json --replace-fail " touch " " ${lib.getExe' coreutils "touch"} "
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Export Bash environment as JSON for import into modern shells like Elvish and Nushell";
    homepage = "https://github.com/tesujimath/bash-env-json";
    mainProgram = "bash-env-json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    platforms = lib.platforms.all;
  };
})
