{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxinerama";
  version = "1.1.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXinerama-${finalAttrs.version}.tar.xz";
    hash = "sha256-UJTR8PzBgoyxaW0NOdnoZq4yUgxU0B9hjxo8HjDCCFw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXinerama \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Library for Xinerama extension to X11 Protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxinerama";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      x11NoPermitPersons
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xinerama" ];
    platforms = lib.platforms.unix;
  };
})
