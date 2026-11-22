{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  gradle,
  jdk25,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "jextract";
  version = "0-unstable-2025-11-12";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "91fc954c46fac907cae6cd1417d835208c9df150";
    hash = "sha256-RAK7A0BCFaYe/q1nCdvXk091bhSj9DKxg2uQfABk4eo=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${lib.getLib llvmPackages.libclang}"
    "-Pjdk_home=${jdk25}"
  ];

  patches = [
    ./copy_lib_clang.patch
  ];

  doCheck = true;

  gradleCheckTask = "verify";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/
    cp -r ./build/jextract $out/opt/jextract
    makeBinaryWrapper "$out/opt/jextract/bin/jextract" "$out/bin/jextract"

    runHook postInstall
  '';

  meta = {
    description = "Tool which mechanically generates Java bindings from a native library headers";
    mainProgram = "jextract";
    homepage = "https://github.com/openjdk/jextract";
    platforms = jdk25.meta.platforms;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      jlesquembre
      sharzy
    ];
  };
}
