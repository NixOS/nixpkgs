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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxfont_2";
  version = "2.0.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXfont2-${finalAttrs.version}.tar.xz";
    hash = "sha256-8EKjcGZoFee5Qem3AZAkdVvRxsKVSvv6UVrzeCUXmeI=";
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

  __structuredAttrs = true;

  meta = {
    description = "X font handling library for server & utilities";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxfont";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      hpnd
      hpndSellVariant
      # this was originally BSD-3-Clause-UC, however the University of California rescinded
      # clause 3, the advertising clause, in 1999 effectively reverting it to a BSD-3-Clause
      bsd3
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xfont2" ];
    platforms = lib.platforms.unix;
  };
})
