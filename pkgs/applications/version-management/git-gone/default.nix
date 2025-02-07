{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    rev = "v${version}";
    hash = "sha256-j88ZnJ0V8h/fthOWwV6B0ZbzUz7THykqrI2QpOkDT4I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fXdWwGkdMhZA9u/xbvRIV6m88q6SQDahU12ZjQZFu3Y=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  postInstall = ''
    installManPage git-gone.1
  '';

  meta = with lib; {
    description = "Cleanup stale Git branches of merge requests";
    homepage = "https://github.com/swsnr/git-gone";
    changelog = "https://github.com/swsnr/git-gone/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-gone";
  };
}
