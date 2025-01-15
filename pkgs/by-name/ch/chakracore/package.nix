{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  python3,
  which,
  icu,
}:
clangStdenv.mkDerivation {
  pname = "chakracore";
  version = "1.13.0.0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "chakra-core";
    repo = "ChakraCore";
    rev = "e26c81f6eabf3b4c0f45c3963be807d3ea90c63e";
    hash = "sha256-74Nan33bE3lgAyLptl/8ZfNYmJSqpmV6GqrsmnWRSNg=";
  };

  nativeBuildInputs = [
    cmake
    python3
    which
    icu
  ];

  dontConfigure = true;

  preBuild = ''
    substituteInPlace  pal/src/config.h.in --replace-fail '#cmakedefine01 MMAP_IGNORES_HINT' '#define MMAP_IGNORES_HINT 0'
  '';

  buildPhase = ''
    runHook preBuild

    bash ./build.sh
    bash ./build.sh --static

    runHook postBuild
  '';

  installPhase =
    let
      DYN_LIB_EXT = clangStdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      runHook preInstall

      install -Dm755 out/Release/ch $out/bin/ch
      install -Dm644 out/Release/bin/ChakraCore/libChakraCore${DYN_LIB_EXT} $out/lib/libChakraCore${DYN_LIB_EXT}

      mv out/Release/include $out/include

      runHook postInstall
    '';

  doInstallCheck = true;

  installCheckPhase = ''
    echo 'console.log("Hello, ChakraCore.");' > test.js
    $out/bin/ch test.js
  '';

  meta = {
    description = "Open source Javascript engine with a C API";
    homepage = "https://github.com/chakra-core/ChakraCore";
    license = with lib.licenses; [ mit ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "ch";
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = with lib.platforms; darwin ++ linux;
  };
}
