{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk,
  makeWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "async-profiler";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "jvm-profiling-tools";
    repo = "async-profiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ggqfBndcwHUerWjsvDqmRQ5uEyL6zhNgwVl18R18k0Q=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jdk ];

  installPhase =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      runHook preInstall
      install -D build/bin/asprof "$out/bin/async-profiler"
      install -D build/lib/libasyncProfiler${ext} "$out/lib/libasyncProfiler${ext}"
      runHook postInstall
    '';

  fixupPhase = ''
    wrapProgram $out/bin/async-profiler --prefix PATH : ${lib.makeBinPath [ jdk ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Low overhead sampling profiler for Java that does not suffer from Safepoint bias problem";
    homepage = "https://github.com/jvm-profiling-tools/async-profiler";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mschuwalow ];
    platforms = lib.platforms.all;
    mainProgram = "async-profiler";
  };
})
