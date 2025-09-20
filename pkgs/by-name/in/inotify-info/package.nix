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
    tag = "v${finalAttrs.version}";
    hash = "sha256-mxZpJMmSCgm5uV5/wknVb1PdxRIF/b2k+6rdOh4b8zA=";
  };

  buildFlags = [ "INOTIFYINFO_VERSION=v${finalAttrs.version}" ];

  installFlags = [ "PREFIX=$$out" ];

  meta = {
    description = "Easily track down the number of inotify watches, instances, and which files are being watched";
    homepage = "https://github.com/mikesart/inotify-info";
    license = lib.licenses.mit;
    mainProgram = "inotify-info";
    maintainers = with lib.maintainers; [ motiejus ];
    platforms = lib.platforms.linux;
  };
})
