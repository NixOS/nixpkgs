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
  version = "0.6.0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "0WD0";
    repo = "majutsu";
    rev = "8eaf8cb4db2f0737d0a131ef8b61ce6393660369";
    hash = "sha256-QqvzRfqWa4Ql7bpuShqHmXzXJCu1VU8ObnImiK7ZyvE=";
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
