{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  nix-update-script,
}:

let
  version = "1.5.2-stable";

  src = fetchFromGitHub {
    owner = "gtsteffaniak";
    repo = "filebrowser";
    tag = "v${version}";
    hash = "sha256-1qG6IayTqL4x3CqJyvVSG8Fu4s6ywhWI9t1j9c+wTZM=";
  };

  frontend = buildNpmPackage {
    pname = "filebrowser-quantum-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";
    npmDepsHash = "sha256-J1PddXU79T0GVcAgxYEW/vraqYxbTvASw8RmW8dDeOw=";

    buildPhase = ''
      runHook preBuild

      npm run build:docker

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';
  };

in
buildGoModule {
  pname = "filebrowser-quantum";
  inherit version src;

  sourceRoot = "${src.name}/backend";

  vendorHash = "sha256-YAMh0WMe1zDCJq8BuPcekb1J8RvRoxOmsZarKI1ZWcs=";

  preBuild = ''
    mkdir -p http/embed
    cp -r ${frontend}/* http/embed/
  '';

  postInstall = ''
    mv $out/bin/backend $out/bin/filebrowser-quantum
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/gtsteffaniak/filebrowser/backend/version.CommitSHA=testingCommit"
    "-X github.com/gtsteffaniak/filebrowser/backend/version.Version=testing"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Access and manage your files from the web";
    homepage = "https://github.com/gtsteffaniak/filebrowser";
    changelog = "https://github.com/gtsteffaniak/filebrowser/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jocimsus
      denperidge
    ];
    mainProgram = "filebrowser-quantum";
  };
}
