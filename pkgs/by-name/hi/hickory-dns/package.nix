{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H8wJozmuXtJ6d96DMgQ/Uw2sp3sa+UKMXT9vf5azcyc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nuT2WUejpIhfI8WVTupAgdo7iav9YL1ipHu/PR4S2Hg=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust based DNS client, server, and resolver";
    homepage = "https://hickory-dns.org/";
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "hickory-dns";
  };
})
