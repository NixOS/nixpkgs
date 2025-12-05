{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  xtrans,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libice";
  version = "1.1.2";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libICE-${finalAttrs.version}.tar.xz";
    hash = "sha256-l05O1BQiXrPHFphd+XCfTajSKmeiiQBmvG38ia0phiU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    xtrans
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libICE \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Inter-Client Exchange Library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libice";
    license = lib.licenses.mitOpenGroup;
    maintainers = [ ];
    pkgConfigModules = [ "ice" ];
    platforms = lib.platforms.unix;
  };
})
