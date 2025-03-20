{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  perl,
}:
stdenvNoCC.mkDerivation {
  pname = "colorgrind";
  version = "0-unstable-2016-07-05";

  src = fetchFromGitHub {
    owner = "renatocf";
    repo = "colorgrind";
    rev = "6b68367c9713075a40c6719cb24217e9437ffa74";
    hash = "sha256-KVR2IeoAkaTXDjEndPvrKUzOf4Zkha20vcH4TTJqXfM=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin colorgrind
    runHook postInstall
  '';

  meta = {
    description = "Perl wrapper for Valgrind with ANSI escape code colored output";
    homepage = "http://renatocf.github.io/colorgrind/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "colorgrind";
  };
}
