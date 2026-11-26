{
  lib,
  melpaBuild,
  fetchFromGitHub,
  nix-update-script,
  magit,
  transient,
  with-editor,
  consult,
  plz,
}:
melpaBuild {
  pname = "majutsu";
  version = "0.7.0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "0WD0";
    repo = "majutsu";
    rev = "154ecea1812f71cf85ede346642297a22a5e1713";
    hash = "sha256-xaDI/RQg2WhndOl7OSVNlR1YbbT1IR5XaLYV+ZgbHP4=";
  };

  packageRequires = [
    magit
    transient
    with-editor
    consult
    plz
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Magit for jujutsu";
    homepage = "https://github.com/0WD0/majutsu";
    maintainers = [ lib.maintainers.shunueda ];
    license = lib.licenses.gpl3Plus;
  };
}
