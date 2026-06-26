{
  faust,
  baseName ? "faust2sc",
  supercollider,
  makeWrapper,
  python3,
  stdenv,
}@args:
let
  faustDefaults = faust.faust2ApplBase (
    args
    // {
      baseName = "${baseName}.py";
    }
  );
in
stdenv.mkDerivation (
  faustDefaults
  // {

    nativeBuildInputs = [ makeWrapper ];

    propagatedBuildInputs = [
      python3
      faust
      supercollider
    ];

    postInstall = ''
      mv "$out/bin/${baseName}.py" "$out"/bin/${baseName}
    '';

    postFixup = ''
      wrapProgram "$out"/bin/${baseName} \
        --append-flags "--import-dir ${faust}/share/faust" \
        --append-flags "--architecture-dir ${faust}/share/faust" \
        --append-flags "--architecture-dir ${faust}/include" \
        --append-flags "-p ${supercollider}" \
        --prefix PATH : "$PATH"
    '';
  }
)
