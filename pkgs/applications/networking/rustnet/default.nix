{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "rustnet";
  version = "0.18.0";

  src = pkgs.fetchurl {
    url = "https://github.com/domcyrus/rustnet/releases/download/v${version}/rustnet-v${version}-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-yAjemn3Qi0GjTG5u7UEXHBJFTCd6ctVacV5UoAX7bWA=";
  };

  nativeBuildInputs = with pkgs; [ autoPatchelfHook libcap ];

  buildInputs = with pkgs; [
    libpcap
    zlib
  ];

  sourceRoot = "rustnet-v${version}-x86_64-unknown-linux-musl";

  installPhase = ''
    runHook preInstall
    # 1. Install the binary
    install -m755 -D rustnet $out/bin/rustnet
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "A cross-platform network monitoring terminal UI tool built with Rust.";
    license = lib.licenses.asl20;
    homepage = "https://github.com/domcyrus/rustnet";
    platforms = [ "x86_64-linux" ];
  };
}
