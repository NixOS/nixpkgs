{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aardvark-dns";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "aardvark-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EQFTkJQaW4f6AFmMP5h24ugK5st1rg9c/QK3WjBORAQ=";
  };

  patches = [
    # Fix builds on musl.
    # https://github.com/containers/aardvark-dns/pull/731
    (fetchpatch2 {
      url = "https://github.com/containers/aardvark-dns/commit/9e73fd8ddde844d755f3f992ca9cd7bb0502d87e.patch?full_index=1";
      hash = "sha256-gUUI5UT7iHXHbDNgzhuooyeZAJ4/IX/QbLIcAPhwF3k=";
    })
  ];

  cargoHash = "sha256-nTcAuhfez2ub+4z9E2YGp5i+JJr9K/PpG22ZvMW5ni4=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${finalAttrs.src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ podman ];
    platforms = lib.platforms.linux;
    mainProgram = "aardvark-dns";
  };
})
