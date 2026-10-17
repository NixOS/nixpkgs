{
  lib,
  pkgsCross,
}:
pkgsCross.wasm32-unknown-none.rustPlatform.buildRustPackage {
  pname = "hello-world";
  version = "0.1.0";
  src = ./hello-world;
  cargoHash = "sha256-5XS50/Q7564YyZf0mMA2eWZ4YipKZcVY4chPwL4mBYk=";
  installPhase = ''
    mkdir -p $out/lib
    cp target/wasm32-unknown-unknown/release/jaw.wasm $out/lib/
  '';
  meta = {
    description = "A simple 'Hello, world!' rust program built for `wasm32-unknown-none`";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mitchmindtree ];
    platforms = lib.platforms.unix ++ [ "wasm32-unknown-none" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
