pkgs:

rec {
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

  markBroken =
    pkg:
    pkg.overrideAttrs (previousAttrs: {
      meta = previousAttrs.meta or { } // {
        broken = true;
      };
    });
}
