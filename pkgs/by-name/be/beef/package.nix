{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages_18,
}:

let
  inherit (llvmPackages_18) libllvm;
in
stdenv.mkDerivation {
  pname = "beef";
  version = "0.43.4-unstable-2024-12-24";

  src = fetchFromGitHub {
    owner = "beefytech";
    repo = "Beef";
    rev = "d5024964c86e4a56a732c78d7f05f3516d18fd70";
    hash = "sha256-MN6O8fJjyP7zGgsepQsVjXQGTDaqovRfj8U8zWNndvo=";
  };

  patches = [
    # Disable testing after building
    # Running the tests gives missing symbol errors in the test binary
    ./disable-tests.patch
  ];

  postPatch = ''
    # upstream hardcodes the platform triple, but ours is slightly different
    # this makes libffi headers findable
    # TODO: come up with a better solution than this
    substituteInPlace BeefRT/CMakeLists.txt \
        --replace-fail 'unknown-linux-gnu' 'pc-linux-gnu'

    # TODO: make sure the other path (/usr/bin/clang++) is replaced with a non-existent path
    substituteInPlace BeefBoot/BootApp.cpp IDE/src/BuildContext.bf IDEHelper/Tests/BeefProj.toml \
        --replace-fail '/usr/bin/c++' '${stdenv.cc}/bin/c++'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    libllvm # the package uses llvm-config to check llvm version correctness
  ];

  buildInputs = [ libllvm ];

  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild

    # TODO: set DYLD_LIBRARY_PATH on darwin?
    # LD_LIBRARY_PATH is set so that libhunspell.so can be found
    export LD_LIBRARY_PATH="$(pwd)/IDE/dist"
    . bin/build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # the _d suffix is for debug binaries
    # the libBeefRT archives need to be located next to the main binaries
    install -Dm755 BeefBuild{,_d} -t "$out"/lib/beef
    install -Dm644 libBeefRT{,_d}.a -t "$out"/lib/beef
    install -Dm755 libhunspell.* -t "$out"/lib

    mkdir -p "$out"/bin
    ln -s "$out"/lib/beef/BeefBuild{,_d} "$out"/bin

    # make BeefBuild able to resolve the default libraries
    cp -r ../../BeefLibs "$out"/lib/beef/BeefLibs
    cat > "$out"/lib/beef/BeefConfig.toml << EOF
    Version = 1
    UnversionedLibDirs = ["$out/lib/beef/BeefLibs"]
    EOF

    runHook postInstall
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "High-performance multi-paradigm open source programming language with a focus on developer productivity";
    homepage = "https://www.beeflang.org/";
    license = lib.licenses.mit;
    mainProgram = "BeefBuild";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
