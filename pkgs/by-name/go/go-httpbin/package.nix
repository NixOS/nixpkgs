{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "2.15.0";
in
buildGoModule {
  inherit version;
  pname = "go-httpbin";

  src = fetchFromGitHub {
    owner = "mccutchen";
    repo = "go-httpbin";
    rev = "v${version}";
    hash = "sha256-B2tStlaFM48jxI7UEE9vK4aOTQZf9/UKBhPdgCQSq5Y=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    platforms = lib.platforms.all;
    mainProgram = "go-httpbin";
    description = "A reasonably complete and well-tested golang port of httpbin, with zero dependencies outside the go stdlib.";
    homepage = "https://httpbingo.org/";
    changelog = "https://github.com/mccutchen/go-httpbin/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fd ];
  };
}
