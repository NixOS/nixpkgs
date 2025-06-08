{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxrender,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxrandr";
  version = "1.5.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXrandr-${finalAttrs.version}.tar.xz";
    hash = "sha256-GtWwZTdfSoWRWqYGEcxkB8BgSSohTX+dryFL51LDtNM=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxrender
  ];

  propagatedBuildInputs = [ libxrender ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXrandr \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Xlib Resize, Rotate and Reflection (RandR) extension library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxrandr";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    pkgConfigModules = [ "xrandr" ];
    platforms = lib.platforms.unix;
  };
})
