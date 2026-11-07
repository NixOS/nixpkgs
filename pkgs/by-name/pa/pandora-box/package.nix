{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "pandora-box";
  version = "0.23.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchCrate {
    pname = "pandora_box";
    inherit version;
    hash = "sha256-obmo4+7yzWoCquViTnuOYxP0GDjGFwDquUYcR8Oy0uQ=";
  };

  cargoHash = "sha256-zH/5pqVOFBs2qAMwDQg0SM4tACWV+eP/4C9FJLZbJ5Y=";

  # Tests are integration tests that exercise the sydbox sandbox and require
  # a real system environment; they cannot run inside the Nix build sandbox.
  doCheck = false;

  meta = {
    description = "Syd's log inspector & profile writer";
    homepage = "https://man.exherbo.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      mio
    ];
    mainProgram = "pandora";
    platforms = lib.platforms.linux;
  };
}
