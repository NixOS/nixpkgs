{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "async-profiler";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "jvm-profiling-tools";
    repo = "async-profiler";
    rev = "v${version}";
    hash = "sha256-0CCJoRjRLq4LpiRD0ibzK8So9qSQymePCTYUI60Oy2k=";
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

  meta = with lib; {
    description = "A low overhead sampling profiler for Java that does not suffer from Safepoint bias problem";
    homepage = "https://github.com/jvm-profiling-tools/async-profiler";
    license = licenses.asl20;
    maintainers = with maintainers; [ mschuwalow ];
    platforms = platforms.all;
    mainProgram = "async-profiler";
  };
}
