{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libESMTP";
  version = "1.1.0";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ openssl ];

  patches = [
    # ld64 on Darwin does not support --version-script, use -exported_symbol
    ./darwin-exported-symbols.patch
  ];

  # The plugin loader looks for sasl-<lowercased mechanism name>, i.e. sasl-cram-md5
  postPatch = ''
    substituteInPlace crammd5/meson.build \
      --replace-fail "shared_module('crammd5'" "shared_module('cram-md5'"
  '';

  # _POSIX_C_SOURCE hides strlcpy, which meson detects as available
  mesonFlags = lib.optional (stdenv.hostPlatform.libc == "glibc") "-Dc_args=-D_DEFAULT_SOURCE";

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Same strlcpy issue as above; also make the SASL plugin loader look
    # for .dylib instead of the hardcoded .so
    NIX_CFLAGS_COMPILE = "-D_DARWIN_C_SOURCE -DDLEXT=\".dylib\"";
  };

  src = fetchFromGitHub {
    owner = "libesmtp";
    repo = "libESMTP";
    rev = "v${finalAttrs.version}";
    sha256 = "1bhh8hlsl9597x0bnfl563k2c09b61qnkb9mfyqcmzlq63m1zw5y";
  };

  meta = {
    description = "Library for Posting Electronic Mail";
    longDescription = ''
      libESMTP is an SMTP client library which manages submission of electronic mail
      via a preconfigured Mail Transport Agent (MTA) such as Exim or Postfix.
      It implements many SMTP extensions including TLS for security
      and PIPELINING for high performance.
    '';
    homepage = "https://libesmtp.github.io/";
    license = lib.licenses.lgpl21Plus;
  };
})
