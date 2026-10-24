{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  buildNpmPackage,
  nix-update-script,
}:

let
  version = "2.0.2-stable";

  src = fetchFromGitHub {
    owner = "gtsteffaniak";
    repo = "filebrowser";
    tag = "v${version}";
    hash = "sha256-xzbEB0V+0Yfmc42dAAGMCfSIwPaWoNgwAKYcSFINcmc=";
  };

  frontend = buildNpmPackage {
    pname = "filebrowser-quantum-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";
    npmDepsHash = "sha256-ZJZtHaeNpHV7n3cT0m7YmBuIGM8CObp3IdQWdSiqbKc=";

    buildPhase = ''
      runHook preBuild

      npm run build:docker -- --outDir dist

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
buildGo127Module {
  pname = "filebrowser-quantum";
  inherit version src;

  sourceRoot = "${src.name}/backend";

  excludedPackages = [ "/scripts/" ];

  vendorHash = "sha256-P3H5kESEd1X5tl0EQyIm680fKz/18KegoPBp1jb69vo=";

  # Tests open database fixtures in _docker for writing
  postUnpack = ''
    chmod -R u+w ${src.name}/_docker
  '';

  preBuild = ''
    cp -r ${frontend}/* internal/web/embed/
  '';

  # goModules inherits preBuild, which would make it depend on the frontend;
  # nix-update then records the npmDepsHash mismatch as vendorHash
  overrideModAttrs = {
    preBuild = "";
  };

  postInstall = ''
    mv $out/bin/backend $out/bin/filebrowser-quantum
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/gtsteffaniak/filebrowser/backend/internal/version.CommitSHA=testingCommit"
    "-X github.com/gtsteffaniak/filebrowser/backend/internal/version.Version=testing"
  ];

  passthru = {
    inherit frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

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
