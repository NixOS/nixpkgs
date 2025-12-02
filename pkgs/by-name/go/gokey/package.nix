{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gokey";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gokey";
    tag = "v${version}";
    hash = "sha256-tJ9nCHhKPrw7SRGsqAlo/tf3tBLF63+CevEXggZADlE=";
  };

  vendorHash = "sha256-Btac9Oi8efqRy+OH49Na3Y6RGehHEmGfvDo2/7EWPL4=";

  meta = with lib; {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = licenses.bsd3;
    maintainers = [ maintainers.confus ];
    mainProgram = "gokey";
  };
}
