{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  sdl3,
  testers,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-net";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-PDnkVqFOMT79wC/hlxsIQRProhIRbAIXBF6hcNKmVbI=";
  };

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ sdl3 ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "SDLNET_SAMPLES_INSTALL" true)
  ];

  postInstall = ''
    moveToOutput "libexec/installed-tests" "$out"
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(3\\..*)"
      ];
    };
  };

  meta = {
    description = "Portable network library for use with SDL";
    homepage = "https://github.com/libsdl-org/SDL_net";
    changelog = "https://github.com/libsdl-org/SDL_net/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "sdl3-net" ];
  };
})
