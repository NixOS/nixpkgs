{
  lib,
  clangStdenv,
  stdenv,
  cmake,
  autoPatchelfHook,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  netcoredbg,
  testers,
}:
let
  pname = "netcoredbg";
  build = "1054";
  release = "3.1.2";
  version = "${release}-${build}";
  hash = "sha256-WORGZXbq6d3sxGqyG8oZSwcBoVaD3D56t9K6PJoKFsM=";

  coreclr-version = "v8.0.16";
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "runtime";
    rev = coreclr-version;
    hash = "sha256-/fSKCIugR3UhqxBxtQRw+Bw+UpaSjB4xj0iBiXJaiR4=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "netcoredbg";
    rev = version;
    inherit hash;
  };

  unmanaged = clangStdenv.mkDerivation {
    inherit src pname version;

    nativeBuildInputs = [
      cmake
      dotnet-sdk
    ];

    hardeningDisable = [ "strictoverflow" ];

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail \
        "cmake_minimum_required(VERSION 2.8.12.2)" \
        "cmake_minimum_required(VERSION 3.10)"
      substituteInPlace third_party/linenoise-ng/CMakeLists.txt --replace-fail \
        "cmake_minimum_required(VERSION 2.6)" \
        "cmake_minimum_required(VERSION 3.10)"
    '';

    preConfigure = ''
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    '';

    cmakeFlags = [
      "-DCORECLR_DIR=${coreclr-src}/src/coreclr"
      "-DDOTNET_DIR=${dotnet-sdk}/share/dotnet"
      "-DBUILD_MANAGED=0"
    ];
  };

  managed = buildDotnetModule {
    inherit
      pname
      version
      src
      dotnet-sdk
      ;
    dotnet-runtime = null;

    projectFile = "src/managed/ManagedPart.csproj";
    nugetDeps = ./deps.json;

    # include platform-specific dbgshim binary in nugetDeps
    dotnetFlags = [ "-p:UseDbgShimDependency=true" ];
    executables = [ ];

    # this passes RID down to dotnet build command
    # and forces dotnet to include binary dependencies in the output (libdbgshim)
    selfContainedBuild = true;
  };
in
stdenv.mkDerivation {
  inherit pname version;
  # managed brings external binaries (libdbgshim.*)
  # include source here so that autoPatchelfHook can do it's job
  src = managed;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib stdenv.cc.cc) ];
  installPhase = ''
    mkdir -p $out/share/netcoredbg $out/bin
    cp ${unmanaged}/* $out/share/netcoredbg
    cp ./lib/netcoredbg/* $out/share/netcoredbg
    # darwin won't work unless we link all files
    ln -s $out/share/netcoredbg/* "$out/bin/"
  '';

  passthru = {
    inherit (managed) fetch-deps;
    tests.version = testers.testVersion {
      package = netcoredbg;
      command = "netcoredbg --version";
      version = "NET Core debugger ${release}";
    };
  };

  meta = with lib; {
    description = "Managed code debugger with MI interface for CoreCLR";
    homepage = "https://github.com/Samsung/netcoredbg";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "netcoredbg";
    maintainers = with maintainers; [
      leo60228
      konradmalik
    ];
  };
}
