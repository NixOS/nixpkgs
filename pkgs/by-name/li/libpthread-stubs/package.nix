{
  lib,
  stdenv,
  fetchurl,
  testers,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpthread-stubs";
  version = "0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libpthread-stubs-${finalAttrs.version}.tar.xz";
    hash = "sha256-WdpWbezOunwqeXCkoDtI2ZBfEmL/lEEKZJIk4z0kQrw=";
  };

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts

      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"

      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Provides a pkg-config file `pthread-stubs.pc` containing the Cflags/Libs flags applicable to programs/libraries that use only lightweight pthread API";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/pthread-stubs";
    # gitlab says x11-distribute-modifications but it's not
    # maybe due to https://github.com/spdx/spdx-online-tools/issues/540
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "pthread-stubs" ];
    platforms = lib.platforms.unix;
  };
})
