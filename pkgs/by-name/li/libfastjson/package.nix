{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfastjson";
  version = "1.2609.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "libfastjson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X2V9yeObar7yE4dss/tW+l3QMnbI4lVl8KdZng1cSQ0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Fast json library for C";
    homepage = "https://github.com/rsyslog/libfastjson";
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
})
