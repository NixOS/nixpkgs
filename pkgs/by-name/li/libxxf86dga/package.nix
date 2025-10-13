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
  pname = "libxxf86dga";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXxf86dga-${finalAttrs.version}.tar.xz";
    hash = "sha256-vkRCdXmAj+OiF9WfUcrnVqJpE+tuTIc4zKtl/1bXmA8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXext
    xorgproto
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXxf86dga \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Client library for the XFree86-DGA extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxxf86dga";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xxf86dga" ];
    platforms = lib.platforms.unix;
  };
})
