{
  lib,
  buildLua,
  curl,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

buildLua (finalAttrs: {
  pname = "material-osc";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "brahmkshatriya";
    repo = "material-osc";
    tag = finalAttrs.version;
    hash = "sha256-xd9EocbiOVY5Z21Hf7Mnn392BHGQ+btBgOBjmGditNE=";
  };

  dontBuild = false;

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.fonttools ]))
  ];

  runtime-dependencies = [ curl ];

  buildPhase = ''
    runHook preBuild
    python3 bundle.py "${finalAttrs.version}"
    runHook postBuild
  '';

  scriptPath = "build/${finalAttrs.version}/scripts/material-osc.lua";

  postInstall = ''
    install -Dm644 "build/${finalAttrs.version}/fonts"/* -t "$out/share/fonts"
  '';

  passthru = {
    fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Quality of life OSC for mpv";
    homepage = "https://github.com/brahmkshatriya/material-osc";
    license = [
      lib.licenses.gpl3Only
      lib.licenses.ofl
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.irgendeinwer ];
  };
})
