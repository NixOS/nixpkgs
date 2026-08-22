{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "gamespy-sdk";
  version = "2.06-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "TheAssemblyArmada";
    repo = "GamespySDK";
    rev = "07e3d15c500415abc281efb74322ab6d9c857eb8";
    hash = "sha256-0mPYVOIVmnEhooU5JW8i0BahPUV8plttd8ccMmXq0gc=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "GS_OPENSSL" false)
    (lib.cmakeBool "GS_BUILD_TESTS" false)
    (lib.cmakeBool "GS_INCLUDE_VOICE" false)
  ];

  dontUseCmakeInstall = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/include
    find . -name libgamespy.a -exec cp {} $out/lib/ \;
    cp -r $PWD/../include/* $out/include/
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/lib/cmake/gamespy
    cp ${./gamespy-config.cmake.in} $out/lib/cmake/gamespy/gamespy-config.cmake
    substituteInPlace $out/lib/cmake/gamespy/gamespy-config.cmake \
      --replace-fail '@out@' "$out"
  '';

  meta = {
    description = "GameSpy SDK for online multiplayer server discovery and matchmaking";
    longDescription = ''
      Reverse-engineered reimplementation of the GameSpy SDK, providing
      client-server communication for multiplayer game lobbies, server
      querying, and NAT negotiation. Used by the Command & Conquer
      community to enable online play via community-hosted server
      replacements.
    '';
    homepage = "https://github.com/TheAssemblyArmada/GamespySDK";
    changelog = "https://github.com/TheAssemblyArmada/GamespySDK/commits/main";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
