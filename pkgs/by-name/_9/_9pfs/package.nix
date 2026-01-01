{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fuse,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "9pfs";
<<<<<<< HEAD
  version = "0.5";
=======
  version = "0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ftrvxmtrx";
    repo = "9pfs";
    tag = version;
<<<<<<< HEAD
    sha256 = "sha256-NT8oIQK8Os3HRZLOH2OvauiCvh5bXZFbeEtTFbzNvrs=";
=======
    sha256 = "sha256-nlJ4Zh13T78r0Dn3Ky/XLhipeMbMFbn0qGCJnUCBd3Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace Makefile --replace "pkg-config" "$PKG_CONFIG"
  '';

  makeFlags = [
    "BIN=$(out)/bin"
    "MAN=$(out)/share/man/man1"
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/ftrvxmtrx/9pfs";
    description = "FUSE-based client of the 9P network filesystem protocol";
    mainProgram = "9pfs";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lpl-102
      bsd2
    ];
  };
}
