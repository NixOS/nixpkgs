{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libfontenc,
  xorgproto,
  freetype,
  xtrans,
  zlib,
  writeScript,
  testers,
  # for inheriting the meta attributes
  libxfont_1,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxfont_2";
  version = "2.0.7";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXfont2-${finalAttrs.version}.tar.xz";
    hash = "sha256-i3uC/eukh2m2lDPo4/u5hKX2vzaLDV9Hq+7EnePljvs=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libfontenc
    xorgproto
    freetype
    xtrans
    zlib
  ];

  propagatedBuildInputs = [ xorgproto ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXfont2 \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    inherit (libxfont_1.meta) description homepage license;
    maintainers = [ ];
    pkgConfigModules = [ "xfont2" ];
    platforms = lib.platforms.unix;
  };
})
