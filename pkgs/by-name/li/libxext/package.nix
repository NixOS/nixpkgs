{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  xorgproto,
  libxau,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxext";
  version = "1.3.6";

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXext-${finalAttrs.version}.tar.xz";
    hash = "sha256-7bWfojmU5AX9xbQAr99YIK5hYLlPNePcPaRFehbol1M=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    xorgproto
  ];
  propagatedBuildInputs = [
    xorgproto
    libxau
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXext \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Xlib-based library for common extensions to the X11 protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxext";
    license = with lib.licenses; [
      mitOpenGroup
      x11
      hpnd
      hpndSellVariant
      hpndDocSell
      hpndDoc
      mit
      isc
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xext" ];
    platforms = lib.platforms.unix;
  };
})
