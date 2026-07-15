{
  lib,
  stdenv,
  fetchurl,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsepol";
  version = "3.10";
  se_url = "https://github.com/SELinuxProject/selinux/releases/download";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/libsepol-${finalAttrs.version}.tar.gz";
    hash = "sha256-1VVYZ5f6nzg0RJbSp+wRR7bKrz/MRMQtjVFz7denmnE=";
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
