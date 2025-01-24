{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-info";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = "inotify-info";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-mxZpJMmSCgm5uV5/wknVb1PdxRIF/b2k+6rdOh4b8zA=";
  };

  buildFlags = [ "INOTIFYINFO_VERSION=v${finalAttrs.version}" ];

  installFlags = [ "PREFIX=$$out" ];

  meta = with lib; {
    description = "Easily track down the number of inotify watches, instances, and which files are being watched";
    homepage = "https://github.com/mikesart/inotify-info";
    license = licenses.mit;
    mainProgram = "inotify-info";
    maintainers = with maintainers; [ motiejus ];
    platforms = platforms.linux;
  };
})
