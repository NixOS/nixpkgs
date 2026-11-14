{
  lib,
  stdenvNoCC,
  ant,
  buildPackages,
}:

lib.makeOverridable (
  lib.fetchers.withNormalizedHash { } (
    {
      outputHash,
      outputHashAlgo,
      ...
    }@args:

    (lib.extendMkDerivation {
      constructDrv = stdenvNoCC.mkDerivation;

      extendDrvArgs =
        finalAttrs:

        {
          antJdk ? buildPackages.jdk,
          nativeBuildInputs ? [ ],
          ...
        }:

        {
          dontConfigure = true;

          nativeBuildInputs = [ ant ] ++ nativeBuildInputs;

          inherit antJdk;

          env = {
            JAVA_HOME = toString (finalAttrs.antJdk.passthru.home or finalAttrs.antJdk);
          };

          inherit outputHash outputHashAlgo;
          outputHashMode = "recursive";

          buildPhase = ''
            runHook preBuild
            concatTo flagsArray buildFlags buildFlagsArray antFlags
            ant init "''${flagsArray[@]}"
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mv bin/libs $out
            runHook postInstall
          '';

          fixupPhase = ''
            runHook preFixup

            find $out -type f \( \
              -name \*.lastUpdated \
              -o -name resolver-status.properties \
              -o -name _remote.repositories \) \
              -delete

            runHook postFixup
          '';
        };

      transformDrv =
        drv:

        drv.overrideAttrs (
          oldAttrs:
          let
            parsed = builtins.parseDrvName drv.name;
          in
          {
            name = "${parsed.name}-ant-deps-${parsed.version}";
          }
        );
    })
      args
  )
)
