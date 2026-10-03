{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lib45d";
  version = "0-unstable-2024-01-29";
  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "lib45d";
    rev = "a607e278182a3184c004c45c215aa22c15d6941d";
    hash = "sha256-N/HC1OJe1Oa66KFdbIwIcCbV4Fi6FPSi0+KAtKJSjds=";
  };

  patches = [
    ./stringstream.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/lib dist/shared/lib45d.so

    mkdir -p $out/include/45d
    cp -f -r src/incl/45d/* $out/include/45d/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/45Drives/lib45d";
    description = "45Drives C++ Library";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jadewilk ];
    platforms = lib.platforms.linux;
  };
})
