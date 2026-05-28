{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "hiraeth";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lukaswrz";
    repo = "hiraeth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GPDGwrYVy9utp5u4iyf0PqIAlI/izcwAsj4yFStYmTE=";
  };

  vendorHash = "sha256-bp9xDB7tplHEBR1Z+Ouks2ZwcktAhaZ/zSSPcu7LWr8=";

  meta = {
    description = "Share files with an expiration date";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.lukaswrz ];
    mainProgram = "hiraeth";
  };
})
