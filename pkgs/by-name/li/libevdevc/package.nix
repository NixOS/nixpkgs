{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libevdevc";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "hugegreenbug";
    repo = "libevdevc";
    rev = "v${finalAttrs.version}";
    sha256 = "0ry30krfizh87yckmmv8n082ad91mqhhbbynx1lfidqzb6gdy2dd";
  };

  postPatch = ''
    substituteInPlace common.mk \
      --replace-fail /bin/echo ${buildPackages.coreutils}/bin/echo
    substituteInPlace include/module.mk \
      --replace-fail /usr/include /include
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=/lib"
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = {
    description = "ChromiumOS libevdev. Renamed to avoid conflicts with the standard libevdev found in Linux distros";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    homepage = "https://chromium.googlesource.com/chromiumos/platform/libevdev/";
    maintainers = with lib.maintainers; [ kcalvinalvin ];
  };
})
