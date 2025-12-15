{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  patsh,
  bashNonInteractive,
  pkg-config,
  gcc,
  gsl,
  targetPackages,
  cc ? targetPackages.stdenv.cc,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "c99sh";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "RhysU";
    repo = "c99sh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nLq6J1PRROTOSvScyyXUqwtj10MEfQCHC8YYNd+JxkA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ patsh ];

  # Used by `patsh`
  buildInputs = [
    bashNonInteractive
    pkg-config
  ];

  postPatch = ''
    patsh c99sh \
      --force --store-dir ${builtins.storeDir} --path "$HOST_PATH"

    patchShebangs .

    substituteInPlace c99sh \
      --replace-fail -cc -${lib.getExe' cc "cc"} \
      --replace-fail -c++ -${lib.getExe' cc "c++"}
  '';

  # FIXME: `patchShebangs` doesn't function in cross-builds
  doCheck = !stdenvNoCC.hostPlatform.isDarwin;

  nativeCheckInputs = [
    pkg-config
    gcc
  ];

  checkInputs = [ gsl ];

  checkPhase = ''
    runHook preCheck

    ./tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin
    cp --no-dereference c*sh $out/bin # c11sh and cxxsh

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Shebang-friendly script for \"interpreting\" C files";
    longDescription = ''
      Shebang-friendly script for \"interpreting\" single C99, C11,
      and C++ files, including rcfile support
    '';
    homepage = "https://github.com/RhysU/c99sh";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "c99sh";
    platforms = lib.platforms.all;
  };
})
