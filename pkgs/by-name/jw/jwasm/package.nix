{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jwasm";
<<<<<<< HEAD
  version = "2.20";
=======
  version = "2.19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Baron-von-Riedesel";
    repo = "JWasm";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ZwSXX/vlAlbRFpWtCmSCGoMT5lu8qz870PZPVktHGRo=";
=======
    hash = "sha256-rWn/PhdOkA8aKDPx5GlfM6RuHcy1Hhudh1auVfaNtdI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "doc"
  ];

  dontConfigure = true;

  preBuild = ''
    cp ${if stdenv.cc.isClang then "CLUnix.mak" else "GccUnix.mak"} Makefile
    substituteInPlace Makefile \
      --replace "/usr/local/bin" "${placeholder "out"}/bin"
  '';

  preInstall = ''
    mkdir -p ${placeholder "out"}/bin
  '';

  postInstall = ''
    install -Dpm644 $src/Html/License.html \
                    $src/Html/Manual.html \
                    $src/Html/Readme.html \
                    -t $doc/share/doc/jwasm/
  '';

  meta = {
    homepage = "https://github.com/Baron-von-Riedesel/JWasm/";
    description = "MASM-compatible x86 assembler";
    changelog = "https://github.com/Baron-von-Riedesel/JWasm/releases/tag/${finalAttrs.src.rev}";
    mainProgram = "jwasm";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
# TODO: generalize for Windows builds
