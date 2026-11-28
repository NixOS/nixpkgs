{
  lib,
  pkgsi686Linux,
  fetchFromGitHub,
  requireFile,
}:

let
  inherit (pkgsi686Linux)
    stdenv
    cmake
    makeWrapper
    python3
    SDL2
    libGL
    ;

  # The port compiles data extracted from the cartridge into the executable, so
  # the ROM is needed at build time, not only at run time.
  baserom = requireFile {
    name = "baserom.u.z64";
    hash = "sha256-LNzsip8MtuNjN/PuOditEF3Ir6a6HALUZuj1t3H5oWI=";
    message = ''
      Project Midas requires a GoldenEye 007 (USA) cartridge image to extract
      game assets from. The image must be the stock 12,582,912 byte dump with
      the SHA-1 abe01e4aeb033b6c0836819f549c791b26cfde83, in big-endian order
      (starting with the bytes 80 37 12 40), and is added to the Nix store
      with:

          nix-store --add-fixed sha256 baserom.u.z64

      Dumps in other byte orders can be converted first, for example the
      common byte-swapped .v64/.n64 dumps with:

          dd if=goldeneye.v64 of=baserom.u.z64 conv=swab

      See https://dumping.guide/carts/nintendo/n64 for dumping instructions.
    '';
  };
in
stdenv.mkDerivation {
  pname = "project-midas";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "murkantor";
    repo = "Project-Midas";
    tag = "v1.0.1";
    hash = "sha256-JkyTsJBfX0aw6yJZPgV131jytHK1JYVDAlv26FiC0Us=";
  };

  patches = [
    # Lets the writable directory holding Data/ (saves, profiles, logs) and
    # midas.ini be moved away from the read-only executable.
    ./0001-Let-GE_ROOT-override-the-exe-relative-data-directory.patch
    # The ROM asset objects are built with a raw compiler invocation, which
    # misses the C standard of the rest of the tree; GCC 15 defaults to C23,
    # where `typedef s32 bool` in bondtypes.h is an error.
    ./0002-Build-the-ROM-asset-objects-as-C11.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    python3
  ];

  buildInputs = [
    SDL2
    libGL
  ];

  hardeningDisable = [
    # The decompiled game code defines its own printf-like functions.
    "format"
    # The tree ships an N64-style include/limits.h with MB_LEN_MAX 5, which
    # glibc's fortified <wchar.h> and <stdlib.h> reject.
    "fortify"
    "fortify3"
    # -fzero-call-used-regs zeroes %eax when returning, but the decompiled code
    # calls functions declared void and uses the value the callee left in
    # %eax: get_ptr_allocated_block_for_vertices() (the vertex allocator) is
    # used as if it returned what dynAllocate() allocated, and doshadow()
    # writing through the resulting NULL pointer crashes on the first level.
    "zerocallusedregs"
  ];

  # GCC 14 and newer turn several constructs the decompiled code is full of
  # (incompatible pointer assignments, implicit declarations, ...) into errors
  # by default; upstream builds with GCC 13, where they are warnings that `-w`
  # in CMakeLists.txt hides.
  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  # Upstream's own build directory, so the ROM extraction tree (build/u, made
  # by `make convert_props`) is not mixed with CMake's.
  cmakeBuildDir = "build_pc";

  postPatch = ''
    patchShebangs --build scripts tools
    substituteInPlace scripts/extract_baserom.u.sh \
      --replace-fail "clear" "true"
  '';

  preConfigure = ''
    # Upstream's build instructions: extract the game assets from the cartridge
    # image, then convert the extracted model binaries to C.
    ln -s ${baserom} baserom.u.z64
    ./scripts/extract_baserom.u.sh
    make convert_props convert_chrs convert_guns combine_images

    # CMakeLists.txt only knows about an SDL2 prefix laid out the way the
    # upstream Docker image builds it (include/SDL2 +
    # lib/i386-linux-gnu/libSDL2.so), so provide one.
    mkdir -p sdl2-prefix/include sdl2-prefix/lib/i386-linux-gnu
    ln -s ${lib.getDev SDL2}/include/SDL2 sdl2-prefix/include/SDL2
    ln -s ${lib.getLib SDL2}/lib/libSDL2.so sdl2-prefix/lib/i386-linux-gnu/libSDL2.so
    cmakeFlagsArray+=("-DSDL2_LINUX_ROOT=$PWD/sdl2-prefix")
  '';

  cmakeFlags = [
    (lib.cmakeBool "GE_VIDEO" true)
    # Compile exactly like upstream does: -O2 and -g come from CMakeLists.txt,
    # and the default build type flags would override them.
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_C_FLAGS_RELEASE="
    "-DCMAKE_CXX_FLAGS_RELEASE="
  ];

  enableParallelBuilding = true;

  # The game reads the controller mappings, the settings help and the shader
  # list from its root directory, so they are installed too.
  installPhase = ''
    runHook preInstall

    cd "$NIX_BUILD_TOP/$sourceRoot"
    install -Dm755 "$cmakeBuildDir/ProjectMidas" $out/libexec/project-midas/ProjectMidas
    install -Dm644 tools/gamecontrollerdb.txt \
                  tools/gamecontrollerdefault.txt \
                  tools/midas_ini_help.txt \
                  -t $out/share/project-midas
    install -Dm644 tools/shaders_base.txt $out/share/project-midas/Data/shaders_base.txt
    install -Dm644 LICENSE -t $out/share/licenses/project-midas
    install -Dm644 tools/THIRD_PARTY_NOTICES.txt -t $out/share/licenses/project-midas

    runHook postInstall
  '';

  postFixup = ''
    # CMakeLists.txt links against SDL2 by absolute path, so the usual rpath
    # fixup does not know that the game needs the library at run time.
    patchelf --add-rpath ${lib.makeLibraryPath [ SDL2 ]} \
      $out/libexec/project-midas/ProjectMidas

    # GE_ROOT makes the game keep its saves, profiles and settings in a
    # writable directory instead of next to the executable, which is in the
    # read-only store.
    makeWrapper $out/libexec/project-midas/ProjectMidas $out/bin/ProjectMidas \
      --argv0 ProjectMidas \
      --set-default GE_ROM ${baserom} \
      --run '
        gameDir="''${XDG_DATA_HOME:-$HOME/.local/share}/project-midas"
        mkdir -p "$gameDir/Data"
        for file in gamecontrollerdb.txt gamecontrollerdefault.txt midas_ini_help.txt; do
          ln -sfn '"$out"'/share/project-midas/"$file" "$gameDir/$file"
        done
        ln -sfn '"$out"'/share/project-midas/Data/shaders_base.txt "$gameDir/Data/shaders_base.txt"
        export GE_ROOT="$gameDir"
      '
  '';

  meta = {
    description = "PC port of the N64 shooter GoldenEye 007, built from the game's decompilation";
    longDescription = ''
      Project Midas is a work-in-progress port of the N64 shooter GoldenEye 007
      to PC, built on top of the game's decompilation.

      Game data is extracted from your own copy of the (USA) cartridge during
      the build, so the ROM image has to be added to the Nix store first; the
      build error message shows how.
    '';
    homepage = "https://github.com/murkantor/Project-Midas";
    license = with lib.licenses; [
      # Project Midas port code
      mit
      # Derivative work of "GoldenEye 007" © 1997 Rare Ltd.
      unfree
    ];
    maintainers = with lib.maintainers; [ PaulGrandperrin ];
    mainProgram = "ProjectMidas";
    # Built for i686 through pkgsi686Linux.
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
  };
}
