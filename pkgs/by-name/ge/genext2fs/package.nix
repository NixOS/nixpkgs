{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genext2fs";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bestouff";
    repo = "genext2fs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9LAU5XuCwwEhU985MzZ2X+YYibvyECULQSn9X2jdj5I=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libarchive
  ];

  configureFlags = [
    "--enable-libarchive"
  ];

  doCheck = true;
  checkPhase = ''
    ./test.sh
  '';

  meta = {
    homepage = "https://github.com/bestouff/genext2fs";
    description = "Tool to generate ext2 filesystem images without requiring root privileges";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "genext2fs";
  };
})
