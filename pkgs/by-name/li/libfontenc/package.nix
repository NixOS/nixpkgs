{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  zlib,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libfontenc";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libfontenc-${finalAttrs.version}.tar.xz";
    hash = "sha256-ewLD1AUjbg2GgGsd6daGj+YMMTYos4NQsDKRSqT9FMY=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    zlib
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X font encoding library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libfontenc";
    license = lib.licenses.mit;
    maintainers = [ ];
    pkgConfigModules = [ "fontenc" ];
    platforms = lib.platforms.unix;
  };
})
