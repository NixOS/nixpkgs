{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  jsoncpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgestures";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "hugegreenbug";
    repo = "libgestures";
    rev = "v${finalAttrs.version}";
    sha256 = "0dfvads2adzx4k8cqc1rbwrk1jm2wn9wl2jk51m26xxpmh1g0zab";
  };
  patches = [ ./include-fix.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace -Werror -Wno-error \
      --replace '$(DESTDIR)/usr/include' '$(DESTDIR)/include'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    jsoncpp
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=/lib"
  ];

  meta = {
    description = "ChromiumOS libgestures modified to compile for Linux";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    homepage = "https://chromium.googlesource.com/chromiumos/platform/gestures";
    maintainers = with lib.maintainers; [ kcalvinalvin ];
  };
})
