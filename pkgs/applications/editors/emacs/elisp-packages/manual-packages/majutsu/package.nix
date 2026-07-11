{
  lib,
  melpaBuild,
  fetchFromGitHub,
  nix-update-script,
  magit,
  transient,
  with-editor,
}:
melpaBuild {
  pname = "majutsu";
  version = "0.6.0-unstable-2026-07-09";

  src = fetchFromGitHub {
    owner = "0WD0";
    repo = "majutsu";
    rev = "59aff9b93eac575fbccc1f4ab2d48d048e0ead9b";
    hash = "sha256-GJ62hsHgLEFIY0ghij0VPFt1jMUGRKhI2eCroBjkxtc=";
  };

  packageRequires = [
    magit
    transient
    with-editor
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Magit for jujutsu";
    homepage = "https://github.com/0WD0/majutsu";
    maintainers = [ lib.maintainers.shunueda ];
    license = lib.licenses.gpl3Plus;
  };
}
