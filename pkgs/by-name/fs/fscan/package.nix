{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "fscan";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-OFlwL7PXKOPKIW2YCirCGCXRCGIWYMmYHMmSU2he/tw=";
  };

  vendorHash = "sha256-+m87ReIUOqaTwuh/t0ow4dODG9/G21Gzw6+p/N9QOzU=";

  meta = with lib; {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
}
