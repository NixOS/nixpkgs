{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

let
  name = "clidle";
  url = "https://github.com/ajeetdsouza/${name}";
in
buildGoModule (finalAttrs: {
  pname = name;
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = name;
    tag = "v${finalAttrs.version}";
    hash = "sha256-WplqB0IvVI/Dyg36xsazhYRpkQxxf+nQo1ye+ewuAiI=";
  };
  vendorHash = "sha256-vevil9MxPr3YcB7m1Jzvypioq6aOkWrQeFCC1fPeQKw=";

  meta = {
    changelog = "${url}/releases/tag/v${finalAttrs.version}";
    homepage = url;
    description = "Play Wordle in your terminal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nicknb ];
    mainProgram = "clidle";
    platforms = lib.platforms.unix;
  };
})
