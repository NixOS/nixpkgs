{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, gradle
, jdk22
, llvmPackages
}:

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2024-03-13";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "b9ec8879cff052b463237fdd76382b3a5cd8ff2b";
    hash = "sha256-+4AM8pzXPIO/CS3+Rd/jJf2xDvAo7K7FRyNE8rXvk5U=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${llvmPackages.libclang.lib}"
    "-Pjdk22_home=${jdk22}"
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
    platforms = jdk22.meta.platforms;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jlesquembre sharzy ];
  };
}
