{
  lib,
  rustPlatform,
  fetchgit,
  fetchpatch2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redisjson";
  version = "2.8.15";

  src = fetchgit {
    url = "https://github.com/RedisJSON/RedisJSON";
    fetchSubmodules = true;
    rev = "v${finalAttrs.version}";
    hash = "sha256-oO9b1GDmmT4dhZUksDS9hu+juYrv3vRGwFNubkPsNBg=";
  };

  cargoHash = "sha256-jmWGIH1gjMgT9slQAQpRuXLpYwD+VlPYtXR2kgGcfu0=";

  cargoPatches = [
    (fetchpatch2 {
      name = "Make rustflags an array";
      url = "https://github.com/RedisJSON/RedisJSON/commit/48d0d9d490d3272d376a0a5690e3ab7e17db70b1.patch?full_index=1";
      hash = "sha256-aw5ynoabJk5RZrQoXtkpUU0x5OOHIoTZ5otzyUYoE2k=";
    })
  ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  meta = {
    homepage = finalAttrs.src.url;
    description = "JSON data type for Redis ";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    changelog = "${finalAttrs.src.url}/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ SchweGELBin ];
  };
})
