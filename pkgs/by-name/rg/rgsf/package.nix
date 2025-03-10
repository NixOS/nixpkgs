{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rgsf";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "IFeelBloated";
    repo = "RGSF";
    rev = "refs/tags/r${lib.versions.major finalAttrs.version}";
    hash = "sha256-/w4z8cv4cl+6e8n+fA9axIRVuDo6gFahxM4Rghkpbv0=";
  };

  buildPhase = ''
    runHook preBuild

    for file in RGVS Clense RemoveGrain Repair VerticalCleaner; do
      $CXX -c -iquote . -o $file.o $file.cpp
    done;

    $CXX -shared -o rgfs.so *.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 rgfs.so -t $out/lib/vapoursynth

    runHook postInstall
  '';

  meta = {
    description = "RGVS Single Precision";
    homepage = "https://github.com/IFeelBloated/RGSF";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.unfree; # unclear license
  };
})
