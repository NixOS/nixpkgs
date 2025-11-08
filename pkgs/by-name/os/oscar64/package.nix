{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscar64";
  version = "1.32.263";

  src = fetchFromGitHub {
    owner = "drmortalwombat";
    repo = "oscar64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g8HUJcoI7fBmypPO79QYiOdhIYh1/sctSaEC8RLaM+s=";
  };

  # FIXME: can be removed whenever the version is bumped.
  patches = [
    (fetchpatch {
      url = "https://github.com/drmortalwombat/oscar64/commit/3b0f954144e36903fd396c099714722f9fa2430a.patch";
      hash = "sha256-6S7Gx9pZSNBHxX9uyS0zApe263dUo5DGviEczpP1FpQ=";
    })
    (fetchpatch {
      url = "https://github.com/drmortalwombat/oscar64/commit/744f496f0f71fae098063a1f3ed71722d31f7b1a.patch";
      hash = "sha256-84UBgVuKN7HMdkQfWUXMCfQSNqAe2QQ2yiifEN1JuOU=";
    })
  ];

  postPatch = ''
    substituteInPlace ./oscar64.1 \
      --replace-fail "/usr/local/bin/oscar64" "$out/bin/oscar64" \
      --replace-fail "/usr/local/share/oscar64/" "$out/include/oscar64"
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "-C ./make"
    "prefix=$(out)"
  ];

  buildTarget = "compiler";

  doCheck = true;
  checkTarget = "check";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Optimizing small memory C compiler, assembler, and runtime for C64";
    homepage = "https://github.com/drmortalwombat/oscar64";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nekowinston ];
    mainProgram = "oscar64";
    platforms = lib.platforms.unix;
    # FIXME: enable aarch64-linux for the next version.
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
})
