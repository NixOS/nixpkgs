{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "galene";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    tag = "galene-${finalAttrs.version}";
    hash = "sha256-VX/k0Ho092VjL+GIPVDgdlHxLWtTE24QHPMGCLjF6Ew=";
  };

  vendorHash = "sha256-v10z9i6sDTXmH6Dp+4O3uAl00dkr9Ig0EaQ2ydQX9as=";

  ldflags = [
    "-s"
  ];
  preCheck = "export TZ=UTC";

  outputs = [
    "out"
    "static"
  ];

  postInstall = ''
    mkdir $static
    cp -r ./static $static
  '';

  passthru = {
    tests = nixosTests.galene;
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=galene-(.*)" ];
    };
  };

  meta = {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    changelog = "https://github.com/jech/galene/blob/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.ngi ];
    mainProgram = "galene";
    maintainers = with lib.maintainers; [
      rgrunbla
      erdnaxe
    ];
  };
})
