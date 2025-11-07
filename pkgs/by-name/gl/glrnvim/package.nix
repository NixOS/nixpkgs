{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "glrnvim";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "beeender";
    repo = "glrnvim";
    rev = "v${version}";
    hash = "sha256-fyJ3k1CBrxL6It8x9jNumzCuhXug6eB/fuvPUQYEc4A=";
  };

  cargoHash = "sha256-xDa2aMWx09dEbRDops2HwYSl/KMA7CeFqS2bnxX/8w8=";

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
}
