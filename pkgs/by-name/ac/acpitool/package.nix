{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

let
  acpitool-patch-051-4 =
    params:
    fetchpatch rec {
      inherit (params) name hash;
      url = "https://salsa.debian.org/debian/acpitool/raw/33e2ef42a663de820457b212ea2925e506df3b88/debian/patches/${name}";
    };

in
stdenv.mkDerivation rec {
  pname = "acpitool";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/acpitool/acpitool-${version}.tar.bz2";
    hash = "sha256-AE+2zUMQKRi2MCz1N6LbfOrdoErvLgkG3fIw+CDa008=";
  };

  patches = [
    (acpitool-patch-051-4 {
      name = "ac_adapter.patch";
      hash = "sha256-KDo2KXIhDl+fmgiadxcn9QILalFwmbg9r6/0tN0mwWY=";
    })
    (acpitool-patch-051-4 {
      name = "battery.patch";
      hash = "sha256-pyb4I2fzWRdPJiCVKtV71QDxHfONyHB7rerhx0rVFaQ=";
    })
    (acpitool-patch-051-4 {
      name = "kernel3.patch";
      hash = "sha256-z7lFPImMD8C4+S2iG5UHne4Lcr5p+onfPDGBbXE8ZOE=";
    })
    (acpitool-patch-051-4 {
      name = "wakeup.patch";
      hash = "sha256-/wjgpEYk4KpKW3Z65NROtStBtriqhmKfPWzrTyxyv9Y=";
    })
    (acpitool-patch-051-4 {
      name = "0001-Do-not-assume-fixed-line-lengths-for-proc-acpi-wakeu.patch";
      hash = "sha256-9Yz06kDmuHM8xxcFmmd5GSqmLQq5fQeQurQuOeiBnIM=";
    })
    (acpitool-patch-051-4 {
      name = "typos.patch";
      hash = "sha256-6ra9MfTv6HrXGi3e1+Id7UJ1Nk7uh+VZuHhpMy926IQ=";
    })
  ];

  meta = {
    description = "Small, convenient command-line ACPI client with a lot of features";
    mainProgram = "acpitool";
    homepage = "https://sourceforge.net/projects/acpitool/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.guibert ];
    platforms = lib.platforms.unix;
  };
}
