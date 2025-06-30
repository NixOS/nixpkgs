{
  lib,
  fetchFromGitHub,
  buildGo124Module,
  buildNpmPackage,
}:

let
  version = "0.7.10-beta";

  src = fetchFromGitHub {
    owner = "gtsteffaniak";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-gxEXSsRc2gGgmpEol9Q9FOlLUJtVL0PdkrLXXhR+8mk=";
  };

  frontend = buildNpmPackage {
    pname = "filebrowser-quantum-frontend";
    inherit version src;

    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    sourceRoot = "source/frontend";
    npmBuildFlags = [ "--verbose" ];
    npmDepsHash = "sha256-ZGF5+bfnSETajicUSbF6tDEfubEUBGRdVFuJRpPFCR0=";

    buildPhase = ''
      npm run build-docker
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';
  };

in
buildGo124Module {
  pname = "filebrowser-quantum";
  inherit version src;

  sourceRoot = "source/backend";

  vendorHash = "sha256-XCXb52c097hkWM+ey20DjthHN4eHNkmQ9E8ZpUN5JZ8=";

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

  meta = with lib; {
    description = "FileBrowser Quantum provides an easy way to access and manage your files from the web";
    homepage = "https://github.com/gtsteffaniak/filebrowser";
    license = licenses.asl20;
    maintainers = with maintainers; [ jocimsus ];
    mainProgram = "filebrowser-quantum";
  };
}
