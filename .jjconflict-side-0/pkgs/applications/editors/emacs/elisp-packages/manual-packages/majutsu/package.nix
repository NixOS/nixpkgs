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
  version = "0.6.0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "0WD0";
    repo = "majutsu";
    rev = "0fdb3c2b3ab826724949cd2cc714f2eff32ec152";
    hash = "sha256-4K5pSnSTh1GpdcQMPkhUouQQ3JM8vR22yBOBgPPo7vI=";
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
