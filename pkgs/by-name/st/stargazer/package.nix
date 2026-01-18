{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  installShellFiles,
  scdoc,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stargazer";
  version = "1.3.4";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-9JNOq9SV3sHDlVaPUnZRq/8WNPQ/iF3AdSvAoCEtg7k=";
  };

  cargoHash = "sha256-p1COGfMjHNZeAWYdVzCo/mHM75Tt5klxtYWn8tAuH0g=";

  passthru = {
    tests.basic-functionality = nixosTests.stargazer;
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postInstall = ''
    scdoc < doc/stargazer.scd  > stargazer.1
    scdoc < doc/stargazer-ini.scd  > stargazer.ini.5
    installManPage stargazer.1
    installManPage stargazer.ini.5
    installShellCompletion completions/stargazer.{bash,zsh,fish}
  '';

  meta = {
    description = "Fast and easy to use Gemini server";
    mainProgram = "stargazer";
    homepage = "https://sr.ht/~zethra/stargazer/";
    license = lib.licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~zethra/stargazer/refs/${version}";
    maintainers = with lib.maintainers; [ gaykitty ];
  };
}
