{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "littlefs-fuse";
  version = "2.7.11";
  src = fetchFromGitHub {
    owner = "littlefs-project";
    repo = "littlefs-fuse";
    rev = "v${version}";
    hash = "sha256-RZpGLFVNo3WEXVU7V2tFjRs8iYN1Ge6AN4Bcq3d6mtc=";
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
