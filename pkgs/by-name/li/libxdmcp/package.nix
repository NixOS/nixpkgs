{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxdmcp";
  version = "1.1.5";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXdmcp-${finalAttrs.version}.tar.xz";
    hash = "sha256-2KUiKCjDratwrfaaVYPx0y617OBDBPf4OStqNTqiIow=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXdmcp \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Display Manager Control Protocol library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxdmcp";
    license = lib.licenses.mitOpenGroup;
    maintainers = [ ];
    pkgConfigModules = [ "xdmcp" ];
    platforms = lib.platforms.unix;
  };
})
