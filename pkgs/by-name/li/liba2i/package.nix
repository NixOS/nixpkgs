{ stdenv
, fetchgit
, lib
, pkgconf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liba2i";
  version = "0.6";

  src = fetchgit {
    url = "git://www.alejandro-colomar.es/src/alx/alx/lib/liba2i.git";
    rev = finalAttrs.version;
    hash = "sha256-JrD1lU8LISeUSksncByQVnPY3IAdeknThewfork8Ma8=";
  };

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace-fail 'SHELL       := /usr/bin/env' "" \
      --replace-fail ".SHELLFLAGS := -S '\$(BASH) -Eeuo pipefail -c'" ""
    substituteInPlace share/mk/build/{lib-shared,lib-static,obj-as,obj-cc,obj-cpp,obj-pch}.mk \
      --replace-fail 'g 0 1 2 s 3 fast' ""
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "DISTVERSION=${finalAttrs.version}"
    "MAJOR_VERSION=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkgconf
  ];

  outputs = [ "out" "dev" ];

  meta = {
    description = "Library to parse numbers from strings";
    homepage = "https://www.alejandro-colomar.es/src/alx/alx/liba2i.git/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
})
