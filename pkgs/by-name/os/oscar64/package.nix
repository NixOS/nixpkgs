{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscar64";
  version = "1.32.271";

  src = fetchFromGitHub {
    owner = "drmortalwombat";
    repo = "oscar64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dVLpzYiGZA2qP2jrSj9Ijc8lJP8kSyWO3pdpLJ2pHJg=";
  };

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
