{
  lib,
  stdenv,
  fetchurl,
  libsepol,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "semodule-utils";
  version = "3.11";

  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/semodule-utils-${finalAttrs.version}.tar.gz";
    hash = "sha256-DFdOFUE/9+1mDEXgEb7+JIu4nqonPbb1brKX1h3rLtY=";
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
