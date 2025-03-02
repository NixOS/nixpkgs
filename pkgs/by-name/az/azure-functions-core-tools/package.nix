{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  buildGoModule,
  dotnetCorePackages,
  versionCheckHook,
}:
let
  version = "4.0.6610";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-functions-core-tools";
    tag = version;
    hash = "sha256-tUNiyvIjaIrdo6377IdXND7YgIk9zKkazDHV4kiWYa8=";
  };
  gozip = buildGoModule {
    pname = "gozip";
    inherit version;
    src = src + "/tools/go/gozip";
    vendorHash = null;
  };
in
buildDotnetModule {
  pname = "azure-functions-core-tools";
  inherit src version;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.sdk_8_0;
  dotnetFlags = [ "-p:TargetFramework=net8.0" ];
  nugetDeps = ./deps.nix;
  useDotnetFromEnv = true;
  executables = [ "func" ];

  postPatch = ''
    substituteInPlace src/Azure.Functions.Cli/Common/CommandChecker.cs \
      --replace-fail "CheckExitCode(\"/bin/bash" "CheckExitCode(\"${stdenv.shell}"
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${gozip}/bin/gozip $out/bin/gozip
  '';

  meta = {
    homepage = "https://github.com/Azure/azure-functions-core-tools";
    description = "Command line tools for Azure Functions";
    mainProgram = "func";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdarocha
      detegr
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
