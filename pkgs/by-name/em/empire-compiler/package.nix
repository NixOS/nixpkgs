{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  lib,
  testers,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "empire-compiler";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "bc-security";
    repo = "empire-compiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BuNg5RetGEV/YAZnZP7rkMHif9NczOx2e4OAVDjafuI=";
  };

  postPatch = ''
    substituteInPlace EmpireCompiler/EmpireCompiler.csproj \
      --replace-fail 'net6.0' 'net9.0'
  '';

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  nugetDeps = ./deps.json;

  projectFile = "EmpireCompiler/EmpireCompiler.csproj";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "EmpireCompiler --version";
      version = "${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://github.com/BC-SECURITY/Empire-Compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    description = "C# Compiler for Empire";
    maintainers = with lib.maintainers; [
      fzakaria
      vrose
    ];
  };
})
