{
  stdenv,
  lib,
  fetchFromGitea,
  curl,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snac2";
  version = "2.83";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grunfink";
    repo = "snac2";
    tag = finalAttrs.version;
    hash = "sha256-5BpJKDXA3PO/ZCfFYMngWaAGns2+ANWCpLgiEi4CAXY=";
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/snac";
  doInstallCheck = true;

  passthru = {
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
