{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "sourcemapper";
  version = "0-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "denandz";
    repo = "sourcemapper";
    rev = "f739bd5dd266b0d0e2cfa17c0a132f79bd9a5ba9";
    hash = "sha256-nOhybCGjy5CNdKDbQPANaVfprZX51Q71bmfxvX38yrw=";
  };

  vendorHash = null;

  meta = {
    description = "Extract JavaScript source trees from Sourcemap files";
    homepage = "https://github.com/denandz/sourcemapper";
    license = lib.licenses.bsd3;
    mainProgram = "sourcemapper";
    maintainers = with lib.maintainers; [
      emilytrau
      crem
    ];
  };
}
