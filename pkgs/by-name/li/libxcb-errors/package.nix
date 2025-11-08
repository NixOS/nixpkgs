{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  python3,
  xcbproto,
  libxcb,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-errors";
  version = "1.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-errors-${finalAttrs.version}.tar.xz";
    hash = "sha256-VijIe5hCWa2Se6zYpClYMZw2vfSwZYh4A8nYIPuA81c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
    python3
  ];

  buildInputs = [
    xcbproto
    libxcb
  ];

  propagatedBuildInputs = [ libxcb ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname xcb-util-errors \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "XCB utility library that gives human readable names to error, event & request codes";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-errors";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xcb-errors" ];
    platforms = lib.platforms.unix;
  };
})
