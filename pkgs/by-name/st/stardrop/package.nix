{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  zip,
}:

buildDotnetModule rec {
  pname = "stardrop";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Floogen";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-VN0SrvBT5JUNraeh6YyRhcnoOl+mOB2/zk/rQeJidI8=";
  };

  patches = [
    ./patches/csproj-for-nix.patch
  ];

  projectFile = "Stardrop/Stardrop.csproj";
  buildInputs = [ zip ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  nugetDeps = ./deps.nix;

  meta = {
    description = "Stardrop is an open-source, cross-platform mod manager for the game Stardew Valley";
    homepage = "https://github.com/Floogen/Stardrop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jh-devv ];
    mainProgram = "stardrop";
    platforms = lib.platforms.all;
  };
}
