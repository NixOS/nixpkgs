{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  fetchpatch,
  libX11,
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
  ];

  postPatch = ''
    substituteInPlace ./make/makefile \
      --replace-fail "/bin/mkdir" "mkdir" \
      --replace-fail "/usr/bin/install" "install" \
      --replace-fail "/usr/bin/sed" "sed"
    substituteInPlace ./oscar64.1 \
      --replace-warn "/usr/local/bin/oscar64" "$out/bin/oscar64" \
      --replace-warn "/usr/local/share/oscar64/" "$out/include/oscar64"
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "-C ./make"
    "prefix=$(out)"
  ];

  buildFlags = [ "compiler" ];

  buildInputs = lib.optionals stdenv.isLinux [
    libX11
  ];

  doCheck = true;
  checkTarget = "check";

  preInstall = ''
    mkdir -p $out/man/man1
  '';

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
