{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule (finalAttrs: {
  pname = "mihomo-manager-mihomo-mixin";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "MihomoManager";
    repo = "MihomoManager.MihomoMixin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9+Dg6LRDmH7AE7J0yCM3kNcdiywUuJRwVS/f6DQPv8c=";
  };

  projectFile = "src/MihomoManager.MihomoMixin/MihomoManager.MihomoMixin.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  nugetDeps = ./deps.nix;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Mihomo configuration merge tool with merge, edit, and JS scripting actions";
    homepage = "https://github.com/MihomoManager/MihomoManager.MihomoMixin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yueyinqiu ];
    mainProgram = "MihomoManager.MihomoMixin";
  };
})
