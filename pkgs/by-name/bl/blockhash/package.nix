{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pkg-config,
  imagemagick,
  wafHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blockhash";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "commonsmachinery";
    repo = "blockhash";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QoqFTCfWtXIrFF3Yx4NfOa9cSjHtCSKz3k3i0u9Qx9M=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    wafHook
  ];
  buildInputs = [ imagemagick ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/commonsmachinery/blockhash";
    description = ''
      This is a perceptual image hash calculation tool based on algorithm
      descibed in Block Mean Value Based Image Perceptual Hashing by Bian Yang,
      Fan Gu and Xiamu Niu.
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "blockhash";
  };
})
