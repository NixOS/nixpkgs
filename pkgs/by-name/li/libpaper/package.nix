{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.2.8";
  pname = "libpaper";

  src = fetchurl {
    url = "https://github.com/rrthomas/libpaper/releases/download/v${finalAttrs.version}/libpaper-${finalAttrs.version}.tar.gz";
    hash = "sha256-HjMFcWkBkYdOykFex2iJ3RG6uYh6IwLWo2Zc0IHE13s=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # The configure script of libpaper is buggy: it uses AC_SUBST on a headerfile
  # to compile sysconfdir into the library. Autoconf however defines sysconfdir
  # as "${prefix}/etc", which is not expanded by AC_SUBST so libpaper will look
  # for config files in (literally, without expansion) '${prefix}/etc'. Manually
  # setting sysconfdir fixes this issue.
  preConfigure = ''
    configureFlagsArray+=(
      "--sysconfdir=$out/etc"
    )
  '';

  # Set the default paper to letter (this is what libpaper uses as default as well,
  # if you call getdefaultpapername()).
  # The user can still override this with the PAPERCONF environment variable.
  postInstall = ''
    mkdir -p $out/etc
    echo letter > $out/etc/papersize
  '';

  meta = {
    changelog = "https://github.com/rrthomas/libpaper/releases/tag/v${finalAttrs.version}";
    description = "Library for handling paper characteristics";
    homepage = "https://github.com/rrthomas/libpaper";
    license = with lib.licenses; [
      gpl2Only
      gpl3Plus
      mit
      publicDomain
    ];
    platforms = lib.platforms.unix;
  };
})
