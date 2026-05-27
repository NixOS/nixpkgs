{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  gradle,
  jdk21,
  llvmPackages_20, # LLVM 21 have breaking change will cause check fail
}:

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2024-02-14";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "0f87c6cdd5d63a7148deb38e16ed4de1306a4573"; # Update jextract 21 with latest fixes
    hash = "sha256-Bji7I6LNMs70drGo5+75OClCrxhOsoLV2V7Wdct6494=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${lib.getLib llvmPackages_20.libclang}"
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

  meta = {
    description = "Tool which mechanically generates Java bindings from a native library headers";
    mainProgram = "jextract";
    homepage = "https://github.com/openjdk/jextract";
    platforms = jdk21.meta.platforms;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sharzy ];
  };
}
