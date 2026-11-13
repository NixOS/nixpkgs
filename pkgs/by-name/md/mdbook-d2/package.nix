{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-d2";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e7A7tvDr3Ze2+nMxCMqNkk7qbWOrqLtXA5W5pENuAv0=";
  };

  cargoHash = "sha256-8T6D0TsW3bLoqPoJPzz710ERziHOd4M3yfquWiyexGI=";
  doCheck = false;

  meta = {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
