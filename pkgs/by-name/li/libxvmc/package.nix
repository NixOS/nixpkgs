{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libX11,
  libXext,
  libXv,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxvmc";
  version = "1.0.14";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXvMC-${finalAttrs.version}.tar.xz";
    hash = "sha256-5L6etra6/bv4H0f3FjBHIVN25F4tx4bQ6mGByTByXtk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libX11
    libXext
    libXv
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXvMC \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X-Video Motion Compensation API";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxvmc";
    license = lib.licenses.mit;
    maintainers = [ ];
    pkgConfigModules = [
      "xvmc"
      "xvmc-wrapper"
    ];
    platforms = lib.platforms.unix;
  };
})
