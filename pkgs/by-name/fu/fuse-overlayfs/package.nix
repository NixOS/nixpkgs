{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "fuse-overlayfs";
    rev = "v${version}";
    hash = "sha256-ngpC1KtUsIJOfpJ9dSqZn9XhKkJSpp2/6RBz/RlZ+A0=";
  };

  meta = with lib; {
    description = "FUSE implementation for overlayfs";
    homepage = "https://github.com/containers/fuse-overlayfs";
    changelog = "https://github.com/containers/fuse-overlayfs/blob/${src.rev}/NEWS";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lampros ];
    mainProgram = "fuse-overlayfs";
    platforms = platforms.all;
  };
}
