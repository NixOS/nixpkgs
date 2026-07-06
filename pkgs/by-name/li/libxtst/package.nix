{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxi,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxtst";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXtst-${finalAttrs.version}.tar.xz";
    hash = "sha256-tQ1MJblwCadEcGwQOcWY9NjmSRDJ/eOBmU4criNdkkI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxi
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXtst \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Library for the XTEST and RECORD X11 extensions";
    longDescription = ''
      The XTEST extension is a minimal set of client and server extensions required to completely
      test the X11 server with no user intervention. This extension is not intended to support
      general journaling and playback of user actions.
      The RECORD extension supports the recording and reporting of all core X protocol and arbitrary
      X extension protocol.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxtst";
    license = with lib.licenses; [
      mitOpenGroup
      hpndSellVariant
      hpndDoc
      x11
      hpndDocSell
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xtst" ];
    platforms = lib.platforms.unix;
  };
})
