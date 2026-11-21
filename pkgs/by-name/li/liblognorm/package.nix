{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libestr,
  json_c,
  pcre2,
  libfastjson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblognorm";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "liblognorm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pkOXAyzYBAfFbT2Pmr/AK3gNF7K2/z9ue6PKdJGI3ts=";
  };

  postPatch = ''
    patchShebangs tests/*.sh
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libestr
    json_c
    pcre2
    libfastjson
  ];

  configureFlags = [ "--enable-regexp" ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/rsyslog/liblognorm/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Help to make sense out of syslog data, or, actually, any event data that is present in text form";
    homepage = "https://www.liblognorm.com/";
    license = lib.licenses.lgpl21;
    mainProgram = "lognormalizer";
    platforms = lib.platforms.all;
  };
})
