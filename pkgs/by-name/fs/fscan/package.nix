{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fscan";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = finalAttrs.version;
    hash = "sha256-OFlwL7PXKOPKIW2YCirCGCXRCGIWYMmYHMmSU2he/tw=";
  };

  vendorHash = "sha256-+m87ReIUOqaTwuh/t0ow4dODG9/G21Gzw6+p/N9QOzU=";

  meta = {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
})
