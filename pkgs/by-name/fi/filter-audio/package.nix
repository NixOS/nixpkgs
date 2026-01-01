{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "filter-audio";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "irungentoo";
    repo = "filter_audio";
    rev = "v${version}";
    sha256 = "1dv4pram317c1w97cjsv9f6r8cdxhgri7ib0v364z08pk7r2avfn";
  };

  doCheck = false;

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Lightweight audio filtering library made from webrtc code";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Lightweight audio filtering library made from webrtc code";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
