{
  lib,
  stdenv,
  nim,
}:

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
    install -Dt $out/bin nim_builder
  '';
  meta = {
    description = "Internal Nixpkgs utility for buildNimPackage";
    mainProgram = "nim_builder";
  };
}
