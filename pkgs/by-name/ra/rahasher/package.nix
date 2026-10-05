{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rahasher";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "LeXofLeviafan";
    repo = "RAHasher";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-PitP2MUNwkcCwNJTet3D+A4/RTWp7Xl5Fpc63o5KRFc=";
  };

  # The upstream Makefile derives src/RA_BuildVer.h from `.git/HEAD` by
  # shelling out to `git describe` etc. (src/RAInterface/MakeBuildVer.sh).
  # fetchFromGitHub doesn't keep a .git directory, so that rule can never
  # fire in the sandbox. Drop the rule and drop in a static header instead;
  # RAHasher only ever prints this version string, it doesn't use it for
  # anything functional.
  postPatch = ''
    sed -i '/^src\/RA_BuildVer\.h: \.git\/HEAD/,+1d' Makefile.RAHasher

    # The vendored zlib-1.3.1 (pulled in via the libchdr submodule for CHD
    # support) calls read/write/close in gzread.c/gzwrite.c without
    # including <unistd.h>, relying on old-style implicit declarations.
    # GCC 14 made -Wimplicit-function-declaration an error by default
    # (independent of -std), so demote it back to a warning explicitly.
    sed -i 's/^CFLAGS=-Wall \$(INCLUDES)/CFLAGS=-Wall -Wno-error=implicit-function-declaration $(INCLUDES)/' Makefile.common

    cat > src/RA_BuildVer.h <<EOF
    #define RA_LIBRETRO_VERSION "${finalAttrs.version}.0"
    #define RA_LIBRETRO_VERSION_SHORT "${finalAttrs.version}"
    #define RA_LIBRETRO_VERSION_MAJOR ${lib.versions.major finalAttrs.version}
    #define RA_LIBRETRO_VERSION_MINOR ${lib.versions.minor finalAttrs.version}
    #define RA_LIBRETRO_VERSION_PATCH ${lib.versions.patch finalAttrs.version}
    #define RA_LIBRETRO_VERSION_REVISION 0
    #define RA_LIBRETRO_VERSION_PRODUCT "${finalAttrs.version}"
    #define RA_LIBRETRO_VERSION_FULL "${finalAttrs.version}"
    #define RA_LIBRETRO_VERSION_COMMIT_HASH ""
    #define RA_LIBRETRO_VERSION_COMMIT_HASH_SHORT ""
    EOF
  '';

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [
    "-f"
    "Makefile.RAHasher"
    "HAVE_CHD=1"
  ];

  enableParallelBuilding = true;

  # No `make install` target upstream; ARCH auto-detection in
  # Makefile.common puts the binary in ./bin (x86) or ./bin64 (x64/arm64).
  installPhase = ''
    runHook preInstall
    install -Dm755 bin*/RAHasher $out/bin/RAHasher
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI utility for verifying ROM checksums with hashing methods used by RetroAchievements";
    longDescription = ''
      RAHasher computes ROM/disc checksums using the same hashing methods as
      RetroAchievements (via the bundled rcheevos library), so you can look
      up or verify RetroAchievements-compatible hashes for your ROM
      collection from the command line. It's a CLI-friendly derivative of
      RALibretro's built-in hasher, and supports CHD disc images.
    '';
    homepage = "https://github.com/LeXofLeviafan/RAHasher";
    changelog = "https://github.com/LeXofLeviafan/RAHasher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "RAHasher";
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
