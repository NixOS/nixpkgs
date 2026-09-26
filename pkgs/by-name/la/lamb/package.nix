{
  lib,
  stdenv,
  fetchFromGitHub,
  gnugrep,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lamb";
  version = "unstable-2025-12-22";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "lamb";
    rev = "50938686d4b8ae929121b62a67243baf72867cde";
    hash = "sha256-ALqjh4DmvysdcGQQrCW87r5rvmCrEWPcViN4zg026nY=";
  };

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  buildPhase = ''
    runHook preBuild
    ${stdenv.cc.targetPrefix}cc -o lamb lamb.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 lamb -t "$out/bin"
    install -Dm644 std.lamb -t "$out/share/lamb"

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeCheckInputs = [
    gnugrep
  ];

  checkPhase = ''
    runHook preCheck

    output="$(
      {
        printf '%s\n' \
          'pair 69 (pair 420 1337)' \
          'xs = pair 69 (pair 420 1337)' \
          'first xs' \
          'second xs' \
          'first (second xs)' \
          ':q'
      } | ./lamb ./std.lamb 2>&1
    )"

    grep -Fq "RESULT: 69" <<<"$output"
    grep -Fq "RESULT: 420" <<<"$output"

    runHook postCheck
  '';

  meta = {
    description = "Tiny pure functional programming language in C";
    homepage = "https://github.com/tsoding/lamb";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "lamb";
    platforms = lib.platforms.unix;
  };
})
