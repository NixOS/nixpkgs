{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pandoc,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jo";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "jpmens";
    repo = "jo";
    tag = finalAttrs.version;
    sha256 = "sha256-1q4/RpxfoAdtY3m8bBuj7bhD17V+4dYo3Vb8zMbI1YU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pandoc
    pkg-config
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-v";
  postInstallCheck = ''
    $out/bin/jo -V > /dev/null
    seq 1 10 | $out/bin/jo -a | grep '^\[1,2,3,4,5,6,7,8,9,10\]$' > /dev/null
  '';
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/jpmens/jo";
    changelog = "https://github.com/jpmens/jo/blob/${finalAttrs.version}/ChangeLog";
    mainProgram = "jo";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      markus1189
    ];
    platforms = lib.platforms.all;
  };
})
