{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  openssl,
}:

stdenv.mkDerivation {
  pname = "email";
  version = "0-unstable-2016-08-08";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deanproxy";
    repo = "eMail";
    rev = "7d23c8f508a52bd8809e2af4290417829b6bb5ae";
    fetchSubmodules = true;
    hash = "sha256-bSTfyRhSWNw4/M3xgX590q34LpiX5rftB3uXkEWgJr0=";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/deanproxy/eMail/pull/61
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/deanproxy/eMail/commit/c3c1e52132832be0e51daa6e0037d5bb79a17751.patch";
      hash = "sha256-EflnaANOi7C5FN2DyqxFOgVCiCBwjBFE8WSDV8zKzZ4=";
    })
  ];

  # opt out of GCC 15's stricter C standards
  # https://github.com/NixOS/nixpkgs/issues/475479
  env.NIX_CFLAGS_COMPILE = toString [ "-std=gnu17" ];

  buildInputs = [ openssl ];

  meta = {
    description = "Command line SMTP client";
    license = lib.licenses.gpl2Plus;
    homepage = "https://deanproxy.com/code";
    platforms = lib.platforms.unix;
    mainProgram = "email";
  };
}
