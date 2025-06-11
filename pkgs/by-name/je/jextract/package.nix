{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  gradle,
  jdk23,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "ab6b30fd189e33a52d366846202f2e9b9b280142";
    hash = "sha256-cFXQo/DpjOuuW+HCP2G9HiOqdgVmmyPd3IXCB9X+w6M=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${lib.getLib llvmPackages.libclang}"
    "-Pjdk_home=${jdk23}"
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

  meta = with lib; {
    description = "Tool which mechanically generates Java bindings from a native library headers";
    mainProgram = "jextract";
    homepage = "https://github.com/openjdk/jextract";
    platforms = jdk23.meta.platforms;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      jlesquembre
      sharzy
    ];
  };
}
