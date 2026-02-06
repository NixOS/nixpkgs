{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "itm-decode";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rtic-scope";
    repo = "itm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYRTh3ClQ1JeKfkEmE63NzMbr22wP9sKQurwkRZiVZI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cortex-m-0.7.4" = "sha256-EqXHntEgAO5qiWOidcy44u0Jo3aSH9oW2H91xf18yLc=";
      "nix-0.23.1" = "sha256-X7Sza6Rw2GQoGk6MIJmJqoZFp4oIkZmNhS82V4I28O4=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "A tool to parse and dump ARM [ITM] packets";
    homepage = "https://github.com/rtic-scope/itm";
    changelog = "https://github.com/rtic-scope/itm/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ scottcowe ];
  };
})
