{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    rev = "v${version}";
    hash = "sha256-bb7xeLxo/qk2yKctaX1JXzru1+tGTt8DmDVH6ZaARkU=";
  };

  cargoHash = "sha256-tngsqAnQ2Um0UCSqBvrnpbDygF6CvL2fi0o9MVY0f4g=";

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
