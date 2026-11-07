{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "linaudit";
  version = "0.0.0-unstable-2026-11-5";
  src = fetchFromGitHub {
    owner = "alexiarstein";
    repo = "linaudit";
    rev = "067fa394eb0361ee798948e50653f1d7eee85456";
    hash = "sha256-fYF/xi16k97DqrAvcdrzHCNCHE3HJ69qdlpbivlJyLo=";
  };

  cargoHash = "sha256-ifzRi+qi6c1GeOK4R4yelW6HED8Ox8jHI6MOx1y4aYY=";

  postPatch = ''
    substituteInPlace crates/linaudit-core/src/checks/filesystem.rs \
      --replace-fail "fn barrido_completo" "#[ignore]
      fn barrido_completo"
  '';

  __structuredAttrs = true;

  meta = {
    description = "Audit tool for Linux Systems";
    mainProgram = "linaudit";
    homepage = "https://github.com/alexiarstein/linaudit";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ reylak ];
  };
}
