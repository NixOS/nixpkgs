{
  lib,
  buildGoModule,
  fetchFromGitLab,
  objectbox-c,
  nix-update-script,
  buildNpmPackage,
}:
let
  pname = "find-my-device-server";
  version = "0.5.0-unstable-2024-07-17";

  src = fetchFromGitLab {
    owner = "Nulide";
    repo = "FindMyDeviceServer";
    rev = "688c5fa945510681a470c8a30e8729e267ec8f3e";
    hash = "sha256-k3qoRxDLGrdoLwAeVCXaghJoPHQoPASp5sB6lycKE3I=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-webapp";
    src = "${src}/web";

    npmDepsHash = "sha256-0YUd2SEd4X9tyqI5qtt6FlBlLPUKjehNNM2dTL8ctTQ=";

    buildPhase = ''
      runHook preBuild

      npm install

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * -t $out

      runHook postInstall
    '';

  };
in

buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-GRgj4ulY+fYzz2Ymk1jbMlV6M0U/OsKWT5Ci6rWnVLA=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [ objectbox-c ];

  postInstall = ''
    mv $out/bin/{cmd,fmdserver}

    mkdir -p $out/share/find-my-device-server/
    cp -r ${frontend}/* -t $out/share/find-my-device-server/
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Server to communicate with the FindMyDevice app and save the latest (encrypted) location";
    homepage = "https://gitlab.com/Nulide/FindMyDeviceServer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "fmd";
  };
}
