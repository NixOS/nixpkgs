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
  version = "4.0";

  src = fetchFromGitHub {
    owner = "jvm-profiling-tools";
    repo = "async-profiler";
    rev = "v${version}";
    hash = "sha256-4S5Lbhqu2V7TzrbFf3G3G4OEYLU6w5lcgUl49k9YqSA=";
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

  meta = with lib; {
    description = "Low overhead sampling profiler for Java that does not suffer from Safepoint bias problem";
    homepage = "https://github.com/jvm-profiling-tools/async-profiler";
    license = licenses.asl20;
    maintainers = with maintainers; [ mschuwalow ];
    platforms = platforms.all;
    mainProgram = "async-profiler";
  };
}
