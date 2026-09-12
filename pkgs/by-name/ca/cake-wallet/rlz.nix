{
  lib,
  openssl,
  perl,
  pkg-config,
  protobuf,
  rustPlatform,
  src,
  stdenv,
  udev,
  version,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cake-wallet-rlz";
  inherit version src;

  sourceRoot = finalAttrs.src.name;
  cargoHash = "sha256-fkNgKal01j5DCIiIMoiyLF7judDqSYohwNriKAnQEBU=";

  nativeBuildInputs = [
    pkg-config
    perl
    protobuf
  ];

  buildInputs = [
    openssl
    udev
  ];

  cargoBuildFlags = [ "--lib" ];
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 \
      target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/librlz.so \
      "$out/lib/librlz.so"
    runHook postInstall
  '';

  meta = {
    description = "Zcash wallet library used by Cake Wallet";
    homepage = "https://github.com/cake-tech/zkool2";
    platforms = lib.platforms.linux;
  };
})
