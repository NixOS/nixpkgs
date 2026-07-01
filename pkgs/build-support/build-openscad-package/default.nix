{ lib, stdenvNoCC }:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  extendDrvArgs =
    finalAttrs:
    {
      pname,
      version,
      libName ? pname,
      installTargets ? [ "." ],

      ...
    }@args:

    {
      inherit
        pname
        version
        libName
        installTargets
        ;

      name = "openscad-package-${finalAttrs.pname}-${finalAttrs.version}";

      installPhase =
        args.installPhase or ''
          runHook preInstall

          local targetDir="$out/share/openscad/libraries/${libName}"
          mkdir -p "$targetDir"

          for target in ${lib.escapeShellArgs installTargets}; do
            case "$target" in
              *'*'*)
                echo "WARNING: $name: installTargets contains '*': '$target'" >&2
                echo "  Shell globs are not supported. If you intended this as a glob, use a Nix fileset or an explicit list of paths instead." >&2
                ;;
            esac

            # Run in a subshell with failglob enabled to hide the default "no match:" bash crash.
            ( shopt -s failglob; cp -r -- "$target" "$targetDir/" ) \
              || { echo "ERROR: $name: target '$target' not found." >&2; exit 1; }
          done

          runHook postInstall
        '';
    };
}
