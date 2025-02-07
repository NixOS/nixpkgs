{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "littlefs-fuse";
  version = "2.7.10";
  src = fetchFromGitHub {
    owner = "littlefs-project";
    repo = "littlefs-fuse";
    rev = "v${version}";
    hash = "sha256-O9fzwN2qItsmDwqtNCsnU76PR/cYx00eeHjuD1HU5X4=";
  };
  buildInputs = [ fuse ];
  installPhase = ''
    runHook preInstall
    install -D lfs $out/bin/littlefs-fuse
    ln -s $out/bin/littlefs-fuse $out/bin/mount.littlefs
    ln -s $out/bin $out/sbin
    runHook postInstall
  '';
  meta = src.meta // {
    description = "FUSE wrapper that puts the littlefs in user-space";
    license = lib.licenses.bsd3;
    mainProgram = "littlefs-fuse";
    inherit (fuse.meta) platforms;
    # fatal error: 'linux/fs.h' file not found
    broken = stdenv.hostPlatform.isDarwin;
  };
}
