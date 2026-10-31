{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "make-ls";
  version = "0.1.25";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "owenrumney";
    repo = "make-ls";
    rev = "v" + finalAttrs.version;
    sha256 = "sha256-0E/aUbhlRliAL8aLOINuWm7YyzVtTpzq5jJiVEGk38Y=";
  };

  goPackagePath = "github.com/owenrumney/make-ls";

  subPackages = [ "cmd/make-ls" ];

  vendorHash = "sha256-HJYqbYDN7HslR4Zar2JnO/xbwgKFffH8tMrUAHYnzFU=";

  doCheck = false;

  meta = with lib; {
    description = "Language Server for Makefiles";
    homepage = "https://github.com/owenrumney/make-ls";
    license = licenses.mit;
    maintainers = with maintainers; [ Freed-Wu ];
    platforms = platforms.all;
    mainProgram = "make-ls";
  };
})
