{
  lib,
  rustPlatform,
  fetchgit,
  fetchpatch2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redisjson";
  version = "2.8.16";

  src = fetchgit {
    url = "https://github.com/RedisJSON/RedisJSON";
    fetchSubmodules = true;
    rev = "v${finalAttrs.version}";
    hash = "sha256-LDP4MztuhJvRJ6jm2ciGb5MRZy0IKXVFfyouDMoyQmo=";
  };

  cargoHash = "sha256-qmEi3MHW2uxENN41+cnho9rX6A2CSewQiceuLfGDk3c=";

  cargoPatches = [
    (fetchpatch2 {
      name = "Make rustflags an array";
      url = "https://github.com/RedisJSON/RedisJSON/commit/48d0d9d490d3272d376a0a5690e3ab7e17db70b1.patch?full_index=1";
      hash = "sha256-aw5ynoabJk5RZrQoXtkpUU0x5OOHIoTZ5otzyUYoE2k=";
    })
  ];

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = {
    homepage = finalAttrs.src.url;
    description = "JSON data type for Redis ";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    changelog = "${finalAttrs.src.url}/releases/tag/v${finalAttrs.version}";
    maintainers = [ lib.maintainers.SchweGELBin ];
  };
})
