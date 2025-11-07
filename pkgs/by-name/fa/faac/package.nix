{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  mp4v2Support ? true,
  mp4v2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faac";
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faac";
    tag = "faac-${finalAttrs.version}";
    hash = "sha256-mSdFnmOOpCJ9lvX1vLyAZdK7m+0cUSdLTScGs+Sh1Rc=";
  };

  configureFlags = lib.optional mp4v2Support "--with-external-mp4v2";

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optional mp4v2Support mp4v2;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = "https://github.com/knik0/faac";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
})
