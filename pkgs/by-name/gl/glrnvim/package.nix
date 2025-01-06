{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "glrnvim";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "beeender";
    repo = "glrnvim";
    rev = "v${version}";
    hash = "sha256-n3t3s3fzmBGXRDydYxNJ13itKul8dyLNW6HP8Di4hY0=";
  };

  cargoHash = "sha256-cHEse+pXwgPTL8GJyY4s1mhWXGTY8Fnn2rFpA5SNerY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    DiskArbitration
    Foundation
  ]);

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
