{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libz";
  version = "1.2.8.2025.03.07";

  src = fetchFromGitLab {
    owner = "sortix";
    repo = "libz";
    tag = "libz-${finalAttrs.version}";
    hash = "sha256-tr9r0X+iHz3LZFgIxi3JMQUnSlyTRtAIhtjwI+DIhpc=";
  };

  outputs = [
    "out"
    "dev"
  ];
  outputDoc = "dev"; # single tiny man3 page

  passthru.updateScript = gitUpdater {
    rev-prefix = "libz-";
  };

  meta = {
    homepage = "https://sortix.org/libz/";
    description = "Clean fork of zlib";
    license = [ lib.licenses.zlib ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
