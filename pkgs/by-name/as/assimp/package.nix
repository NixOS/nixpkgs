{
  lib,

  stdenv,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  bzip2,
  kuba-zip,
  minizip-ng,
  openddl-parser,
  openssl,
  pugixml,
  stb,
  utf8cpp,
  zip,
  zlib,
  xz,
  zstd,

  # checkInputs
  gtest,
  rapidjson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "assimp";
  version = "6.0.2";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ixtqK+3iiL17GEbEVHz5S6+gJDDQP7bVuSfRMJMGEOY=";
  };

  patches = [
    (replaceVars ./unvendor.patch {
      inherit stb;
    })
  ];

  postPatch = ''
    substituteInPlace code/AssetLib/OpenGEX/OpenGEXImporter.cpp --replace-fail \
      "prop->m_key->m_text.m_buffer" \
      "prop->m_key->m_buffer"
    substituteInPlace /build/source/code/AssetLib/OpenGEX/OpenGEXImporter.cpp --replace-fail \
      "currentName->m_id->m_text.m_buffer" \
      "currentName->m_id->m_buffer" 
    substituteInPlace /build/source/code/AssetLib/OpenGEX/OpenGEXImporter.cpp --replace-fail \
      "&prop->m_key->m_text" \
      "prop->m_key"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bzip2
    kuba-zip
    minizip-ng
    openddl-parser
    openssl
    pugixml
    stb
    utf8cpp
    xz
    zip
    zlib
    zstd
  ];

  checkInputs = [
    gtest
    rapidjson
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "ASSIMP_BUILD_ASSIMP_TOOLS" true)
    (lib.cmakeBool "ASSIMP_HUNTER_ENABLED" true) # Tell assimp we have a package manager. But we wont use it.
  ];

  # Some matrix tests fail on non-86_64-linux:
  # https://github.com/assimp/assimp/issues/6246
  # https://github.com/assimp/assimp/issues/6247
  doCheck = !(stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isx86_64);
  checkPhase = ''
    runHook preCheck
    bin/unit
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/assimp/assimp/releases/tag/${finalAttrs.src.tag}";
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
