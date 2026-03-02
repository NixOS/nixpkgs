{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gokey";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gokey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tJ9nCHhKPrw7SRGsqAlo/tf3tBLF63+CevEXggZADlE=";
  };

  vendorHash = "sha256-Btac9Oi8efqRy+OH49Na3Y6RGehHEmGfvDo2/7EWPL4=";

  meta = {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.confus ];
    mainProgram = "gokey";
  };
})
