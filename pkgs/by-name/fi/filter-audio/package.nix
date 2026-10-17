{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filter-audio";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "irungentoo";
    repo = "filter_audio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1m0l8pkXgU/M2GDFE/ODvTGUjUtbS3YSD+yEUVW+ZLc=";
  };

  doCheck = false;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Lightweight audio filtering library made from webrtc code";
    homepage = "https://github.com/irungentoo/filter_audio";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
