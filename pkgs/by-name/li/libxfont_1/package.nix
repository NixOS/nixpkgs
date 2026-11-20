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
  pname = "libxfont_1";
  version = "1.5.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXfont-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Gn90kHdMh/IFLRRtHg5kUY0y5oSBhKGGVOjQu1eIMkI=";
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

  # prevents "misaligned_stack_error_entering_dyld_stub_binder"
  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "CFLAGS=-O0";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXfont \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

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
    pkgConfigModules = [ "xfont" ];
    platforms = lib.platforms.unix;
  };
})
