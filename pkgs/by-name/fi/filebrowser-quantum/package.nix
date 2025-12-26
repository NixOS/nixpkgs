{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
}:

let
  version = "1.0.3-stable";

  src = fetchFromGitHub {
    owner = "gtsteffaniak";
    repo = "filebrowser";
    tag = "v${version}";
    hash = "sha256-nNfJswCMsd47f7x6vCnjhf/HE8gX5nBy3VK23KH/nMY=";
  };

  frontend = buildNpmPackage {
    pname = "filebrowser-quantum-frontend";
    inherit version src;

    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    sourceRoot = "${src.name}/frontend";
    npmDepsHash = "sha256-u7CzKG4+tBeq3JvTEPIPySs8/u9tfF308Zv43g+7klA=";

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

  vendorHash = "sha256-urJZMOkZzoN//kecpJ47ldZk+H2qvMGTr/Pw90bMpDc=";

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
