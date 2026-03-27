{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ludtwig";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zRroSPI41PU1sPwvKALWkydGWYJrz5uDJ94uimsCNys=";
  };

  checkType = "debug";

  cargoHash = "sha256-cGxstBXNwyzQRNfedTbbO8Qf9C7VlMf2asz7VgQfZaA=";

  meta = {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      maltejanz
    ];
    mainProgram = "ludtwig";
  };
})
