{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libcaesium";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "Lymphatus";
    repo = "libcaesium";
    tag = finalAttrs.version;
    hash = "sha256-PIdt7t0w5I6uG7QLT3487Wkv1Gj0LFiULgVzH3Gj12o=";
  };

  # https://github.com/Lymphatus/libcaesium/pull/29
  # add cargoHash in next release (0.17.5)
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Lossy/lossless image compression library";
    homepage = "https://github.com/Lymphatus/libcaesium";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.unix;
  };
})
