{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iir1";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "berndporr";
    repo = "iir1";
    rev = finalAttrs.version;
    hash = "sha256-9HyQr96yGE6hyd/3BN7xJN4yowHCc/zNRUqyw4r1wlg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://berndporr.github.io/iir1/";
    description = "DSP IIR realtime filter library written in C++";
    downloadPage = "https://github.com/berndporr/iir1";
    changelog = "https://github.com/berndporr/iir1/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
