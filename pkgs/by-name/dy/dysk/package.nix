{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-B6iEssB9+BUXO4p1aSzrOGlBA8TiUOZY7a9U8F9SXaQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qfKNxLtvVaXGVP0wzOoZ5jaViO4hcMoZIOqxrpXiWzc=";

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
    platforms = platforms.linux;
  };
}
