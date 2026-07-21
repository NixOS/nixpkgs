{
  lib,
  stdenv,
  fetchurl,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsepol";
  version = "3.11";
  se_url = "https://github.com/SELinuxProject/selinux/releases/download";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/libsepol-${finalAttrs.version}.tar.gz";
    hash = "sha256-efPSyI9Et+tc9U2XkuAyMil+F/l6F5Fj8nUAmaAPFk0=";
  };

  nativeBuildInputs = [ flex ];

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(bin)/bin"
    "INCDIR=$(dev)/include/sepol"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN8DIR=$(man)/share/man/man8"
    "SHLIBDIR=$(out)/lib"
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [
    "DISABLE_SHARED=y"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  enableParallelBuilding = true;

  passthru = { inherit (finalAttrs) se_url; };

  meta = {
    description = "SELinux binary policy manipulation library";
    homepage = "http://userspace.selinuxproject.org";
    platforms = lib.platforms.linux;
    # Note: changing maintainers here changes maintainers for all SELinux-related libraries
    maintainers = with lib.maintainers; [
      RossComputerGuy
      numinit
    ];
    license = lib.licenses.gpl2Plus;
    pkgConfigModules = [ "libselinux" ];
  };
})
