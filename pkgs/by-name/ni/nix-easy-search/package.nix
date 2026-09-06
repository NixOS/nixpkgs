{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nix-easy-search";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Sh0rtRound-wq";
    repo = "NixEasySearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LvWXZlTUVVJpcjKdVDojyuw246RgOm9dDh9LgWAT49I=";
  };

  vendorHash = null;

  strictDeps = true;
  __structuredAttrs = true;

  postInstall = ''
    mv $out/bin/nix-easy-search $out/bin/nes
  '';

  meta = {
    description = "Fast NixOS package search CLI with clean output";
    homepage = "https://github.com/Sh0rtRound-wq/NixEasySearch";
    license = lib.licenses.mit;
    mainProgram = "nes";
    maintainers = [ lib.maintainers.sh0rtround ];
    platforms = lib.platforms.unix;
  };
})
