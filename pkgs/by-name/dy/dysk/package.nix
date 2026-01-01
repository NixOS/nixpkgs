{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
<<<<<<< HEAD
  version = "3.6.0b";
=======
  version = "3.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XkZ21dy6mIStRVqkqESSO6apD6SEeuyYDSsjBdY2+Mg=";
  };

  cargoHash = "sha256-PGHcQZCGwy/yzMrLbz1eO7zlvJI0vrRMKtj3ap13fD0=";
=======
    hash = "sha256-0P7JySrgIui6sWh/JSqGqAMbI9cqeAkSdPuRtJB/Hec=";
  };

  cargoHash = "sha256-UuJ7ya/qLU2kmAhP8aucDREXKjdTaiKlzbSgDZXj54o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
