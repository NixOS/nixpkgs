{
  lib,
  stdenv,
  fetchFromGitHub,
  copyPkgconfigItems,
  makePkgconfigItem,
}:

stdenv.mkDerivation rec {
  pname = "stb";
  version = "unstable-2024-11-09";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "5c205738c191bcb0abc65c4febfa9bd25ff35234";
    hash = "sha256-JeVkoaGZnxSE3EAIwImz/ArPcOee2++5Q8c3mwfLCr0=";
  };

  nativeBuildInputs = [ copyPkgconfigItems ];

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "stb";
      version = "1";
      cflags = [ "-I${variables.includedir}/stb" ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
      };
      inherit (meta) description;
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include/stb
    cp *.h $out/include/stb/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Single-file public domain libraries for C/C++";
    homepage = "https://github.com/nothings/stb";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
