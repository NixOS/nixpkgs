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

  mesonFlags = lib.optional (stdenv.hostPlatform.libc == "glibc") "-Dc_args=-D_DEFAULT_SOURCE";

  src = fetchFromGitHub {
    owner = "libesmtp";
    repo = "libESMTP";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vvAf6jCY/sqwdzWtaXEwKwEm5jCFOrtAP6kkqilEEK4=";
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
