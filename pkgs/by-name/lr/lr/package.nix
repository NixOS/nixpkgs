{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lr";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-zpHThIB1FS45RriE214SM9ZQJ1HyuBkBi/+PTeJjEFc=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/chneukirchen/lr";
    description = "List files recursively";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vikanezrimaya ];
    mainProgram = "lr";
  };
})
