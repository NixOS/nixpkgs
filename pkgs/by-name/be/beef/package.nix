{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  cmake,
  ninja,
  llvmPackages_18,
}:

let
  inherit (llvmPackages_18) libllvm;
in
stdenv.mkDerivation {
  pname = "beef";
  version = "0.43.4-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "beefytech";
    repo = "Beef";
    rev = "861913d5912659d3abe1b9a4705e812fb6c86dce";
    hash = "sha256-tvFou3iS/bOprxUykFb1lXUtJJMren21o3pKJQp1US8=";
  };

  patches = [
    # Disable testing after building
    # Running the tests gives missing symbol errors in the test binary
    ./disable-tests.patch

    # override c++ compiler path used
    # currently doesn't consider cross compilation
    (replaceVars ./set-cpp-compiler.patch {
      cpp = "${stdenv.cc}/bin/c++";
    })
  ];

  postPatch = ''
    # TODO: come up with something better or better explain what this does
    #      (TLDR: makes cmake find libffi headers and object files)
    substituteInPlace BeefRT/CMakeLists.txt \
        --replace-fail 'unknown-linux-gnu' 'pc-linux-gnu'
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
    description = "High-performance multi-paradigm open source programming language with a focus on developer productivity";
    homepage = "https://www.beeflang.org/";
    license = lib.licenses.mit;
    mainProgram = "BeefBuild";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
