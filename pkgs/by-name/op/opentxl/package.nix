{
  lib,
  stdenv,
  makeWrapper,
  opentxl-unwrapped,
  targetPackages,
}:
let
  inherit (targetPackages.stdenv.cc) targetPrefix;

  crossCompiling = stdenv.hostPlatform != stdenv.targetPlatform;
  targetOpentxl = if !crossCompiling then opentxl-unwrapped else targetPackages.opentxl-unwrapped;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${targetPrefix}opentxl-wrapper";
  inherit (opentxl-unwrapped) version;
  preferLocalBuild = true;
  strictDeps = true;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # Wrap compiler
    makeWrapper ${opentxl-unwrapped}/bin/txlc \
      $out/bin/${targetPrefix}txlc \
      --set TXLLIB ${opentxl-unwrapped}/lib \
      --set BUILD_TXLLIB ${opentxl-unwrapped}/lib \
      --set TARGET_TXLLIB ${targetOpentxl}/lib \
      --set CC ${targetPackages.stdenv.cc}/bin/${targetPrefix}cc \
      --set OS ${opentxl-unwrapped.osOption stdenv.targetPlatform}
    ${
      # For convenience, if there is a target prefix, create a symlink named txlc
      lib.optionalString (targetPrefix != "") ''
        ln -s $out/bin/${targetPrefix}txlc $out/bin/txlc
      ''
    }

    # Wrap other scripts
    for name in txl2c txlp; do
      makeWrapper "${opentxl-unwrapped}/bin/$name" \
        "$out/bin/$name" \
        --set-default TXLLIB ${opentxl-unwrapped}/lib
    done

    # Link to binaries that don't need wrapping
    for name in txl txldb; do
      ln -s "${opentxl-unwrapped}/bin/$name" "$out/bin/$name"
    done

    runHook postInstall
  '';

  passthru = {
    unwrapped = opentxl-unwrapped;
    inherit (opentxl-unwrapped.passthru) tests;
  };

  meta = opentxl-unwrapped.meta // {
    platforms = lib.platforms.unix;
  };
})
