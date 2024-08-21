{ lib, stdenv, nim }:

stdenv.mkDerivation {
  pname = "nim_builder";
  inherit (nim) version;
  dontUnpack = true;
  nativeBuildInputs = [ nim ];
  buildPhase = ''
    cp ${./nim_builder.nim} nim_builder.nim
    nim c --nimcache:$TMPDIR nim_builder
  '';
  installPhase = ''
    runHook preInstall

    install -Dt $out/bin nim_builder

    runHook postInstall
  '';
  meta = {
    description = "Internal Nixpkgs utility for buildNimPackage";
    mainProgram = "nim_builder";
    maintainers = [ lib.maintainers.ehmry ];
  };
}
