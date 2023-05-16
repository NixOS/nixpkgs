{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cEMFbG7L48s1SigLD/HfQ2NplGZPpO+KIgs3oV3rgQQ=";
  };

  cargoHash = "sha256-CCPVjOWM59ELd4AyT968v6kvGdVwkMxxLZGDiJlLkzA=";
=======
    hash = "sha256-bb7xeLxo/qk2yKctaX1JXzru1+tGTt8DmDVH6ZaARkU=";
  };

  cargoHash = "sha256-tngsqAnQ2Um0UCSqBvrnpbDygF6CvL2fi0o9MVY0f4g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    maintainers = [ maintainers.marsam ];
  };
}
