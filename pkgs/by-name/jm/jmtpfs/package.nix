{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  file,
  fuse,
  libmtp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jmtpfs";
  version = "0.5";

  src = fetchFromGitHub {
    sha256 = "1pm68agkhrwgrplrfrnbwdcvx5lrivdmqw8pb5gdmm3xppnryji1";
    rev = "v${finalAttrs.version}";
    repo = "jmtpfs";
    owner = "JasonFerrara";
  };

  patches = [
    # Fix Darwin build (https://github.com/JasonFerrara/jmtpfs/pull/12)
    (fetchpatch {
      url = "https://github.com/JasonFerrara/jmtpfs/commit/b89084303477d1bc4dc9a887ba9cdd75221f497d.patch";
      sha256 = "0s7x3jfk8i86rd5bwhj7mb1lffcdlpj9bd7b41s1768ady91rb29";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    file
    fuse
    libmtp
  ];

  meta = {
    description = "FUSE filesystem for MTP devices like Android phones";
    homepage = "https://github.com/JasonFerrara/jmtpfs";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.coconnor ];
    mainProgram = "jmtpfs";
  };
})
