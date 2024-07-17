{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  gradle,
  jdk21,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2023-11-27";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "8730fcf05c229d035b0db52ee6bd82622e9d03e9"; # Update jextract 21 with latest fixes
    hash = "sha256-Wct/yx5C0EjDtDyXNYDH5LRmrfq7islXbPVIGBR6x5Y=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${llvmPackages.libclang.lib}"
    "-Pjdk21_home=${jdk21}"
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
    platforms = jdk21.meta.platforms;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sharzy ];
  };
}
