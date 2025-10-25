{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscar64";
  version = "1.32.265";

  src = fetchFromGitHub {
    owner = "drmortalwombat";
    repo = "oscar64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nPwebydRFHoIWp2sbfPaudKj/sPZRKamYdIuSVZ9dcc=";
  };

  patches = [
    # broke 'make install'
    (fetchpatch {
      url = "https://github.com/drmortalwombat/oscar64/commit/edde3a0076067b961189361c26b9ead9b7e61a4a.patch";
      hash = "sha256-tCW4vA4mcNZ3GBPmgSer5Ix7xyzZslieB+zl1ohtMXU=";
      revert = true;
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
  };
})
