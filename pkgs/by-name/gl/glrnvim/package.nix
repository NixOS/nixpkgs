{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glrnvim";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "beeender";
    repo = "glrnvim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gfcSii45EH6+3nwoUqZv47EPh3ISQE7SeHJWeTXOQz8=";
  };

  cargoHash = "sha256-8sKY5uqWap01klJlZ3CnLAqRFeRSbt7K7jRL8XPDBQ4=";

  postInstall = ''
    install -Dm644 glrnvim.desktop -t $out/share/applications
    install -Dm644 glrnvim.svg $out/share/icons/hicolor/scalable/apps/glrnvim.svg
  '';

  meta = {
    description = "Really fast & stable neovim GUI which could be accelerated by GPU";
    homepage = "https://github.com/beeender/glrnvim";
    mainProgram = "glrnvim";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aacebedo ];
  };
})
