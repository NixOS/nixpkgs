pkgs: lib:

rec {
  addPackageRequires =
    pkg: packageRequires: addPackageRequiresWhen pkg packageRequires (finalAttrs: previousAttrs: true);

  addPackageRequiresIfOlder =
    pkg: packageRequires: version:
    addPackageRequiresWhen pkg packageRequires (
      finalAttrs: previousAttrs: lib.versionOlder finalAttrs.version version
    );

  addPackageRequiresWhen =
    pkg: packageRequires: predicate:
    pkg.overrideAttrs (
      finalAttrs: previousAttrs: {
        packageRequires =
          if predicate finalAttrs previousAttrs then
            previousAttrs.packageRequires or [ ] ++ packageRequires
          else
            previousAttrs.packageRequires or null;
      }
    );

  buildWithGit =
    pkg:
    pkg.overrideAttrs (previousAttrs: {
      nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [ pkgs.git ];
    });

  dontConfigure = pkg: pkg.overrideAttrs { dontConfigure = true; };

  externalSrc =
    pkg: epkg:
    pkg.overrideAttrs (previousAttrs: {
      inherit (epkg) src version;
      propagatedUserEnvPkgs = previousAttrs.propagatedUserEnvPkgs or [ ] ++ [ epkg ];
    });

  fix-rtags = pkg: dontConfigure (externalSrc pkg pkgs.rtags);

  fixRequireHelmCore =
    pkg:
    pkg.overrideAttrs (previousAttrs: {
      postPatch =
        previousAttrs.postPatch or ""
        + "\n"
        + ''
          substituteInPlace $ename.el \
            --replace-fail "(require 'helm)" "(require 'helm-core)"
        '';
    });

  ignoreCompilationError = pkg: ignoreCompilationErrorWhen pkg (finalAttrs: previousAttrs: true);

  ignoreCompilationErrorIfOlder =
    pkg: version:
    ignoreCompilationErrorWhen pkg (
      finalAttrs: previousAttrs: lib.versionOlder finalAttrs.version version
    );

  ignoreCompilationErrorWhen =
    pkg: predicate:
    pkg.overrideAttrs (
      finalAttrs: previousAttrs: {
        ignoreCompilationError = predicate finalAttrs previousAttrs;
      }
    );

  markBroken =
    pkg:
    pkg.overrideAttrs (previousAttrs: {
      meta = previousAttrs.meta or { } // {
        broken = true;
      };
    });

  mkHome = pkg: mkHomeWhen pkg (finalAttrs: previousAttrs: true);

  mkHomeIfOlder =
    pkg: version:
    mkHomeWhen pkg (finalAttrs: previousAttrs: lib.versionOlder finalAttrs.version version);

  mkHomeWhen =
    pkg: predicate:
    pkg.overrideAttrs (
      finalAttrs: previousAttrs: {
        preInstall =
          if predicate finalAttrs previousAttrs then
            ''
              HOME=$(mktemp -d)
            ''
            + previousAttrs.preInstall or ""
          else
            previousAttrs.preInstall or null;
      }
    );
}
