{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "sokol";
  version = "0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol";
    rev = "38e4c9a516f8808d706343a5c525acfe7007fe67";
    sha256 = "sha256-g4JMCbG9is7uBFv6cTBTCmRYfKWMruagtYQjYZnOFn4=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/sokol
    cp *.h $out/include/sokol/
    cp -R util $out/include/sokol/util

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Minimal cross-platform standalone C headers";
    homepage = "https://github.com/floooh/sokol";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jonnybolton ];
=======
  meta = with lib; {
    description = "Minimal cross-platform standalone C headers";
    homepage = "https://github.com/floooh/sokol";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ jonnybolton ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
