{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "galene";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    tag = "galene-${finalAttrs.version}";
    hash = "sha256-eXpaVGS5SuguM/TnfLIKC32DJdRi08kNh+VxG4Et15s=";
  };

  vendorHash = "sha256-wzvdPslFtFSJlo0lp/LqqnWGFxs73qP7ixiE2iiI2GA=";

  ldflags = [
    "-s"
    "-w"
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
    tests.vm = nixosTests.galene.basic;
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=galene-(.*)" ];
    };
  };

  meta = {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    changelog = "https://github.com/jech/galene/raw/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      rgrunbla
      erdnaxe
    ];
  };
})
