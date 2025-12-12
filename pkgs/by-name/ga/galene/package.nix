{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "galene";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    tag = "galene-${finalAttrs.version}";
    hash = "sha256-+ERoH2DsEMJNs3eGTBr4I+2+EdEKBfWnVRFKZ8igA6g=";
  };

  vendorHash = "sha256-r9W/2Uead/EHKWnnJLL9bdA/MazLbe1UsgVXkPNFnxM=";

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
