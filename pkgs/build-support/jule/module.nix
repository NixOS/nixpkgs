{
  julec,
  clang,
  stdenv,
  lib,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      nativeBuildInputs ? [ ],

      # Directory containing the main source file.
      srcDir ? "./src",

      # Directory containing unit tests.
      testDir ? srcDir,

      # Additional arguments to pass to `julec` during the build phase.
      buildArgs ? [ ],

      # Additional arguments to pass to `julec` during the check phase.
      checkArgs ? [ ],

      meta ? { },

      ...
    }@args:
    let
      mainProgram = meta.mainProgram or finalAttrs.pname;
    in
    {
      inherit
        srcDir
        testDir
        buildArgs
        checkArgs
        ;

      nativeBuildInputs = [
        julec
        clang
      ]
      ++ nativeBuildInputs;

      # The following inheritance behavior is not trivial to expect, and some may
      # argue it's not ideal. Changing it may break vendor hashes in Nixpkgs and
      # out in the wild. In anycase, it's documented in:
      # doc/languages-frameworks/jule.section.md.
      prePatch = finalAttrs.prePatch or "";
      patches = finalAttrs.patches or [ ];
      patchFlags = finalAttrs.patchFlags or [ ];
      postPatch = finalAttrs.postPatch or "";
      preBuild = finalAttrs.preBuild or "";
      postBuild = finalAttrs.modPostBuild or "";
      env = finalAttrs.env or { };

      buildPhase = ''
        runHook preBuild

        echo "Building ${mainProgram} ${finalAttrs.version}..."
        mkdir -p bin
        julec --opt L2 -p -o "bin/${mainProgram}" ${lib.escapeShellArgs buildArgs} "${srcDir}"

        runHook postBuild
      '';

      doCheck = args.doCheck or true;
      checkPhase = ''
        runHook preCheck

        echo "Building tests for ${mainProgram} ${finalAttrs.version}..."
        mkdir -p bin
        julec test -o "bin/${mainProgram}-test" ${lib.escapeShellArgs checkArgs} "${testDir}"
        echo "Running tests for ${mainProgram} ${finalAttrs.version}..."
        "./bin/${mainProgram}-test"

        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp "bin/${mainProgram}" $out/bin/

        runHook postInstall
      '';

      meta = {
        platforms = julec.meta.platforms or lib.platforms.unix;
      }
      // meta;
    };
}
