{
  lib,
  stdenv,
  fetchFromGitHub,
  patsh,
  pkg-config,
  bashNonInteractive,
  targetPackages,
  cc ? targetPackages.stdenv.cc,
}:

stdenv.mkDerivation {
  pname = "c99sh";
  version = "1.1.0-unstable-2024-02-12";

  src = fetchFromGitHub {
    owner = "RhysU";
    repo = "c99sh";
    rev = "60f9e1b045fb0b98a1c5ff35556703c4176b26ef";
    hash = "sha256-nLq6J1PRROTOSvScyyXUqwtj10MEfQCHC8YYNd+JxkA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ patsh ];

  buildInputs = [
    pkg-config
    bashNonInteractive # FIXME: patchShebangs doesn't function in cross-builds
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/
    cp --no-dereference c*sh $out/bin # c11sh and cxxsh
    patsh -f $out/bin/c99sh -s ${builtins.storeDir} --path "$HOST_PATH"
    substituteInPlace $out/bin/c99sh \
      --replace-fail -cc -${lib.getBin cc}/bin/cc \
      --replace-fail -c++ -${lib.getBin cc}/bin/c++

    runHook postInstall
  '';

  meta = {
    description = "Shebang-friendly script for \"interpreting\" single C99, C11, and C++ files, including rcfile support";
    homepage = "https://github.com/RhysU/c99sh";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "c99sh";
  };
}
