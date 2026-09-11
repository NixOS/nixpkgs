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
  pname = "libwindowswm";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libWindowsWM-${finalAttrs.version}.tar.bz2";
    hash = "sha256-JfB8+EfL6R02wg80i0uUlMRQT+ApZujN9lz1YxanDtw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libWindowsWM \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "library for Cygwin/X rootless window management extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libwindowswm";
    license = lib.licenses.mit;
    maintainers = [ ];
    pkgConfigModules = [ "windowswm" ];
    platforms = lib.platforms.unix;
  };
})
