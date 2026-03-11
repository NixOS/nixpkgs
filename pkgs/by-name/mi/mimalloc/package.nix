{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  secureBuild ? false,
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mimalloc";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-fk6nfyBFS1G0sJwUJVgTC1+aKd0We/JjsIYTO+IOfyg=";
  };

  doCheck = !stdenv.hostPlatform.isStatic;
  preCheck =
    let
      ldLibraryPathEnv = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      export ${ldLibraryPathEnv}="$(pwd)/build:''${${ldLibraryPathEnv}}"
    '';

  nativeBuildInputs = [
    cmake
    ninja
  ];
  cmakeFlags = lib.mapAttrsToList lib.cmakeBool {
    MI_INSTALL_TOPLEVEL = true;
    MI_SECURE = secureBuild;
    MI_BUILD_SHARED = stdenv.hostPlatform.hasSharedLibraries;
    MI_LIBC_MUSL = stdenv.hostPlatform.libc == "musl";
    MI_BUILD_TESTS = finalAttrs.doCheck;

    # MI_OPT_ARCH is inaccurate (e.g. it assumes aarch64 == armv8.1-a).
    # Nixpkgs's native platform configuration does a better job.
    MI_NO_OPT_ARCH = true;
  };

  postPatch = ''
    substituteInPlace cmake/mimalloc-config.cmake \
      --replace-fail 'string(REPLACE "/lib/cmake" "/lib" MIMALLOC_LIBRARY_DIR "''${MIMALLOC_CMAKE_DIR}")' \
                     "set(MIMALLOC_LIBRARY_DIR \"$out/lib\")" \
      --replace-fail 'string(REPLACE "/lib/cmake/" "/lib/" MIMALLOC_OBJECT_DIR "''${CMAKE_CURRENT_LIST_DIR}")' \
                     "set(MIMALLOC_OBJECT_DIR \"$out/lib\")"
  '';

  postInstall =
    let
      rel = lib.versions.majorMinor finalAttrs.version;
      suffix = if stdenv.hostPlatform.isLinux then "${soext}.${rel}" else ".${rel}${soext}";
    in
    ''
      # first, move headers and cmake files, that's easy
      mkdir -p $dev/lib
      mv $out/lib/cmake $dev/lib/

      find $dev $out -type f
    ''
    + (lib.optionalString secureBuild ''
      # pretend we're normal mimalloc
      ln -sfv $out/lib/libmimalloc-secure${suffix} $out/lib/libmimalloc${suffix}
      ln -sfv $out/lib/libmimalloc-secure${suffix} $out/lib/libmimalloc${soext}
      ln -sfv $out/lib/libmimalloc-secure.a $out/lib/libmimalloc.a
      ln -sfv $out/lib/mimalloc-secure.o $out/lib/mimalloc.o
    '');

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Compact, fast, general-purpose memory allocator";
    homepage = "https://github.com/microsoft/mimalloc";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      kamadorueda
      thoughtpolice
    ];
  };
})
