{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk,
  makeWrapper,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "async-profiler";
<<<<<<< HEAD
  version = "4.2.1";
=======
  version = "4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jvm-profiling-tools";
    repo = "async-profiler";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ggqfBndcwHUerWjsvDqmRQ5uEyL6zhNgwVl18R18k0Q=";
=======
    hash = "sha256-y/MQgXoaJSwc6QjTPGQRFNyVoR1ENQ7rDmtCwR5F/oM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Low overhead sampling profiler for Java that does not suffer from Safepoint bias problem";
    homepage = "https://github.com/jvm-profiling-tools/async-profiler";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mschuwalow ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Low overhead sampling profiler for Java that does not suffer from Safepoint bias problem";
    homepage = "https://github.com/jvm-profiling-tools/async-profiler";
    license = licenses.asl20;
    maintainers = with maintainers; [ mschuwalow ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "async-profiler";
  };
}
