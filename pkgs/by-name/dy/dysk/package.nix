{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    tag = "v${version}";
    hash = "sha256-0P7JySrgIui6sWh/JSqGqAMbI9cqeAkSdPuRtJB/Hec=";
  };

  cargoHash = "sha256-UuJ7ya/qLU2kmAhP8aucDREXKjdTaiKlzbSgDZXj54o=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      koral
      osbm
    ];
    mainProgram = "dysk";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
