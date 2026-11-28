{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jwasm";
  version = "2.21";

  src = fetchFromGitHub {
    owner = "Baron-von-Riedesel";
    repo = "JWasm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a91A2AXNYaZQ7Q1/C8ghD49POqA5vn9bJuXu7E1W8Jg=";
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
    license = lib.licenses.watcom;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
# TODO: generalize for Windows builds
