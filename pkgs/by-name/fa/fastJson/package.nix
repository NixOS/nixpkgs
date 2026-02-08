{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastjson";
  version = "1.2304.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "libfastjson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WnM6lQjHz0n5BwWWZoDBavURokcaROXJW46RZen9vj4=";
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
