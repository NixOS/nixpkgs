{
  buildGoModule,
  fetchFromSourcehut,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "openring";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "openring";
    rev = finalAttrs.version;
    sha256 = "sha256-BY2AtgZXzPLqHk3hd6D+XXbrwvWS9DNTKwLqsua/3uw=";
  };

  vendorHash = "sha256-BbBTmkGyLrIWphXC+dBaHaVzHuXRZ+4N/Jt2k3nF7Z4=";

  # The package has no tests.
  doCheck = false;

  meta = {
    description = "Webring for static site generators";
    homepage = "https://sr.ht/~sircmpwn/openring";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sumnerevans ];
    mainProgram = "openring";
  };
})
