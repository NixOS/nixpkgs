{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXext,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxxf86vm";
  version = "1.1.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXxf86vm-${finalAttrs.version}.tar.xz";
    hash = "sha256-lq9BTHPOHVRJrQS+f58n+oMw+ES23ahD7yLj4b77PuM=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXext
    xorgproto
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXxf86vm \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Extension library for the XFree86-VidMode X extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxxf86vm";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xxf86vm" ];
    platforms = lib.platforms.unix;
  };
})
