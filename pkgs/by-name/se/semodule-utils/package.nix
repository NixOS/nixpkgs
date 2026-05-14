{
  lib,
  stdenv,
  fetchurl,
  libsepol,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "semodule-utils";
  version = "3.10";

  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/semodule-utils-${finalAttrs.version}.tar.gz";
    hash = "sha256-HC8UzAmMu011kS0THF90fnAkbhBC5y8qtA4o9Tz0XBA=";
  };

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = {
    description = "SELinux policy core utilities (packaging additions)";
    license = lib.licenses.gpl2Only;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
})
