{
  lib,
  stdenvNoCC,
  buildPackages,
}:

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

      __structuredAttrs = true;
      name = "openscad-package-${finalAttrs.pname}-${finalAttrs.version}";

      strictDeps = true;

      # Use the interactive Bash shell (with readline support) for the compgen shell built-in.
      realBuilder = lib.getExe buildPackages.bash;

      installPhase =
        args.installPhase or ''
          runHook preInstall

          installDir="$out/share/openscad/libraries/$libName"
          mkdir -p "$installDir"

          for _target in "''${installTargets[@]}"; do
            _targetDirName="$(dirname "$_target")"
            _targetBaseName="$(basename "$_target")"
            # Support globs using Bash's compgen built-in.
            (
              if [[ "$_targetDirName" != "." ]]; then
                if ! cd "$_targetDirName"; then
                  echo "ERROR: $name: Fails to switch to the dirname of $_target -- $_targetDirName" >&2
                  exit 1
                fi
              fi
              if [[ "$_targetBaseName" == "." ]]; then
                echo "$_targetBaseName"
              else
                if ! compgen -G "$_targetBaseName"; then
                  echo "ERROR: $name: Glob $_target does not match any files or directories." >&2
                  exit 1
                fi
              fi
            # Keep the number of input files per batch under Bash's command length limitation.
            ) | while read -r _line; do
              printf "%s/%s\0" "$_targetDirName" "$_line"
            done | xargs -0 cp -r -t "$installDir"
          done

          runHook postInstall
        '';
    };
}
