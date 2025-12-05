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
  version = "0.5";

  src = fetchFromGitHub {
    owner = "ftrvxmtrx";
    repo = "9pfs";
    tag = version;
    sha256 = "sha256-NT8oIQK8Os3HRZLOH2OvauiCvh5bXZFbeEtTFbzNvrs=";
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
