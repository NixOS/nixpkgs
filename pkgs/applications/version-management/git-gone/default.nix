{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    rev = "v${version}";
    hash = "sha256-cEMFbG7L48s1SigLD/HfQ2NplGZPpO+KIgs3oV3rgQQ=";
  };

  cargoHash = "sha256-CCPVjOWM59ELd4AyT968v6kvGdVwkMxxLZGDiJlLkzA=";

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
