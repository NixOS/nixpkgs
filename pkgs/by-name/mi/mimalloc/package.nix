{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  secureBuild ? false,
  localDynamicTLS ? false,
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mimalloc";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-C0cqYiXxx8tW3plUZrfAJYKeY36opGKymkZ/CWrVuEI=";
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
  cmakeFlags = [
    (lib.cmakeBool "MI_INSTALL_TOPLEVEL" true)
    (lib.cmakeBool "DMI_SECURE" secureBuild)
    (lib.cmakeBool "MI_BUILD_SHARED" (
      !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.hasSharedLibraries
    ))
    (lib.cmakeBool "MI_LIBC_MUSL" (stdenv.hostPlatform.libc == "musl"))
    (lib.cmakeBool "MI_LOCAL_DYNAMIC_TLS" localDynamicTLS)
    (lib.cmakeBool "MI_BUILD_TESTS" finalAttrs.doCheck)

    # MI_OPT_ARCH is inaccurate (e.g. it assumes aarch64 == armv8.1-a).
    # Nixpkgs's native platform configuration does a better job.
    (lib.cmakeBool "MI_OPT_ARCH" false)
  ];

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

  meta = with lib; {
    description = "Compact, fast, general-purpose memory allocator";
    homepage = "https://github.com/microsoft/mimalloc";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      kamadorueda
      thoughtpolice
    ];
  };
})
