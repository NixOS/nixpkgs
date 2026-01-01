{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "fastjson";
  version = "1.2304.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "libfastjson";
    tag = "v${version}";
    hash = "sha256-WnM6lQjHz0n5BwWWZoDBavURokcaROXJW46RZen9vj4=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

<<<<<<< HEAD
  meta = {
    description = "Fast json library for C";
    homepage = "https://github.com/rsyslog/libfastjson";
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
=======
  meta = with lib; {
    description = "Fast json library for C";
    homepage = "https://github.com/rsyslog/libfastjson";
    license = licenses.mit;
    maintainers = with maintainers; [ nequissimus ];
    platforms = with platforms; unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
