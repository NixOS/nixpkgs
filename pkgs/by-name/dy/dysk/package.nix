{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-VJFcdxwj+038d9oj178e0uGQQyKF9JbDytxDmit2tiA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vVU10Mj+dRIAOREQiGIO0S+mDBeLtM5v0KjmmoCn3/g=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      koral
    ];
    mainProgram = "dysk";
  };
}
