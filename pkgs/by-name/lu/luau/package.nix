{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  nix-update-script,
  enableVector4 ? false,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableExternC ? !enableStatic,
}:

# extern C is required when building as shared libraries
assert (!enableStatic) -> enableExternC;

let
  # Skip building/running tests if:
  # - cross-compiling (because checkPhase isn't executed anyway)
  # - vector4 is enabled, because there is a Conformance test that does not
  # take into account vector4
  skipTests = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform) || enableVector4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "luau";
  version = "0.709";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    tag = finalAttrs.version;
    hash = "sha256-qqexX0d/YFBbn/l59l3OI7KMpwScAtdmeJbGWk8ZEuE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin luau
    install -Dm755 -t $out/bin luau-analyze
    install -Dm755 -t $out/bin luau-compile
    install -Dm755 -t $out/bin luau-reduce
    install -Dm755 -t $out/bin luau-ast
    install -Dm755 -t $out/bin luau-bytecode

    mkdir -p $out/lib
    cp *.{so,a} $out/lib

    mkdir -p $dev
    cp -r ../{Analysis,Ast,Common,Config,CLI,Compiler,Require,VM,CodeGen}/include $dev

    runHook postInstall
  '';

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.optionalString enableVector4 "-DCMAKE_CXX_FLAGS=-DLUA_VECTOR_SIZE=4")

    (lib.cmakeBool "LUAU_BUILD_SHARED" (!enableStatic))
    (lib.cmakeBool "LUAU_EXTERN_C" enableExternC)

    # To avoid /build/ leaking into RPATH
    (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
    (lib.cmakeBool "LUAU_BUILD_TESTS" (!skipTests))
  ];

  # Without this the linking step fails due to undefined references
  postPatch = lib.optionalString (!enableStatic) ''
    substituteInPlace VM/include/luaconf.h \
      --replace-fail "#define LUAI_FUNC __attribute__((visibility(\"hidden\"))) extern" "#define LUAI_FUNC extern"
  '';

  doCheck = !skipTests;

  checkPhase = ''
    runHook preCheck

    # HACK: since CMAKE_SKIP_RPATH is enabled, set LD_LIBRARY_PATH
    # to the build directory so that the test executables can find
    # the libLuau*.so libraries.
    #
    # I don't think there will be any problems since the test executables
    # aren't installed anyway, but advice is always welcome.
    ${lib.optionalString (!enableStatic) ''export LD_LIBRARY_PATH="$(realpath .)"''}

    # enabling extern C fails this specific test case
    ./Luau.UnitTest ${lib.optionalString enableExternC ''--test-case-exclude="interrupt_execution"''}
    ./Luau.Conformance
    ./Luau.CLI.Test

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/luau-lang/luau/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      prince213
      HeitorAugustoLN
    ];
    mainProgram = "luau";
  };
})
