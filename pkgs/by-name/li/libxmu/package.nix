{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxt,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxmu";
  version = "1.2.1";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXmu-${finalAttrs.version}.tar.xz";
    hash = "sha256-/LJ3kySKOeX8xbnErsQMwHNLPKdqrD19HCZOf34U6LI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxt
  ];

  propagatedBuildInputs = [
    xorgproto
    libx11
    libxt
  ];

  buildFlags = [ "BITMAP_DEFINES='-DBITMAPDIR=\"/no-such-path\"'" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXmu \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X miscellaneous utility routines library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxmu";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
      x11
      isc
    ];
    maintainers = [ ];
    pkgConfigModules = [
      "xmu"
      "xmuu"
    ];
    platforms = lib.platforms.unix;
  };
})
