{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmnl";
  version = "1.0.5";

  src = fetchurl {
    url = "https://netfilter.org/projects/libmnl/files/libmnl-${finalAttrs.version}.tar.bz2";
    hash = "sha256-J0ubkZ7zFSv7PaOhPJUN1g1uK81UIw/+yimNA7QNBSU=";
  };

  meta = {
    description = "Minimalistic user-space library oriented to Netlink developers";
    longDescription = ''
      libmnl is a minimalistic user-space library oriented to Netlink developers.
      There are a lot of common tasks in parsing, validating, constructing of both the Netlink
      header and TLVs that are repetitive and easy to get wrong.
      This library aims to provide simple helpers that allow you to re-use code and avoid
      re-inventing the wheel.
    '';
    homepage = "https://netfilter.org/projects/libmnl/index.html";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ azey7f ];
  };
})
