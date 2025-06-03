{
  lib,
  stdenv,
  fetchurl,
  testers,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-util";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-util-${finalAttrs.version}.tar.xz";
    hash = "sha256-XJ9kEjwZSxUP7okEmZFoc4bm/zbvKve4C6U++vNozJU=";
  };

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts

      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/font/ \
        | sort -V | tail -n1)"

      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X.Org font package creation/installation utilities";
    homepage = "https://gitlab.freedesktop.org/xorg/font/util";
    license = with lib.licenses; [
      mit
      bsd2
      bsdSourceCode
      mitOpenGroup
      # there is a bit of a diff, but i think its close enough
      # it was probably just adapted a bit to fit to the repository structure
      # or its an older version that the one on spdx
      unicodeTOU
    ];
    maintainers = [ ];
    pkgConfigModules = [ "fontutil" ];
    platforms = lib.platforms.unix;
  };
})
