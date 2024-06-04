{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    rev = "v${version}";
    hash = "sha256-Mc9/P4VBmLOC05xqdx/yopbhvdpQS3uejc4YA7BIgug=";
  };

  cargoHash = "sha256-NyyficEDJReMLAw2VAK2fOXNIwHilnUqQRACGck+0Vo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage git-gone.1
  '';

  meta = with lib; {
    description = "Cleanup stale Git branches of merge requests";
    homepage = "https://github.com/swsnr/git-gone";
    changelog = "https://github.com/swsnr/git-gone/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "git-gone";
  };
}
