{
  lib,
  melpaBuild,
  fetchFromGitHub,
  nix-update-script,
  magit,
  difftastic,
}:

melpaBuild {
  pname = "magit-difftastic";
  version = "0-unstable-2026-10-07";

  src = fetchFromGitHub {
    owner = "rschmukler";
    repo = "magit-difftastic";
    rev = "9394ab5e7a29d4507cc69471ea13a14a4bf78da1";
    hash = "sha256-+/eF/FFgwdRX0wX2reCoNXmwIgH7ZsoJLJXGKqN6Vsk=";
  };

  packageRequires = [
    magit
    difftastic
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Integrate difftastic into magit";
    homepage = "https://github.com/rschmukler/magit-difftastic";
    maintainers = [ lib.maintainers.shunueda ];
    license = lib.licenses.mit;
  };
}
