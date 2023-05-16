{ faust
, baseName ? "faust2sc"
, supercollider
, makeWrapper
, python3
, stdenv
}@args:
let
  faustDefaults = faust.faust2ApplBase
    (args // {
      baseName = "${baseName}.py";
    });
in
stdenv.mkDerivation (faustDefaults // {

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ python3 faust supercollider ];

  postInstall = ''
    mv "$out/bin/${baseName}.py" "$out"/bin/${baseName}
  '';

  postFixup = ''
<<<<<<< HEAD
=======
    # export parts of the build environment
    mkdir "$out"/include
    # until pr #887 is merged and released in faust we need to link the header folders
    ln -s "${supercollider}"/include/SuperCollider/plugin_interface "$out"/include/plugin_interface
    ln -s "${supercollider}"/include/SuperCollider/common "$out"/include/common
    ln -s "${supercollider}"/include/SuperCollider/server "$out"/include/server
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram "$out"/bin/${baseName} \
      --append-flags "--import-dir ${faust}/share/faust" \
      --append-flags "--architecture-dir ${faust}/share/faust" \
      --append-flags "--architecture-dir ${faust}/include" \
<<<<<<< HEAD
      --append-flags "-p ${supercollider}" \
=======
      --append-flags "-p $out" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --prefix PATH : "$PATH"
  '';
})
