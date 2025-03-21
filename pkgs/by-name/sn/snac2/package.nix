{
  stdenv,
  lib,
  fetchFromGitea,
  curl,
  openssl,
  nix-update-script,
  testers,
  snac2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snac2";
  version = "2.73";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grunfink";
    repo = "snac2";
    tag = finalAttrs.version;
    hash = "sha256-5LKDwp5f5BWhm+9uVBlv3mJpLLQ+ETP9lcRXlfD579Y=";
  };

  buildInputs = [
    curl
    openssl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Dst_mtim=st_mtimespec"
      "-Dst_ctim=st_ctimespec"
    ]
  );

  passthru = {
    tests.version = testers.testVersion {
      package = snac2;
      command = "${finalAttrs.meta.mainProgram} || true";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://codeberg.org/grunfink/snac2/src/tag/${finalAttrs.version}/RELEASE_NOTES.md";
    description = "Simple, minimalistic ActivityPub instance (2.x, C)";
    homepage = "https://codeberg.org/grunfink/snac2";
    license = lib.licenses.mit;
    mainProgram = "snac";
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = lib.platforms.unix;
  };
})
