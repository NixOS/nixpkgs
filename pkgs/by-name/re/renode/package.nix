{
  callPackage,
  dotnet-runtime_6,
  dotnet-sdk_6,
  nix-update-script,
  ...
}:

(callPackage ./common.nix {
  dotnet-runtime = dotnet-runtime_6;
  dotnet-sdk = dotnet-sdk_6;
  version = "1.15.3";
  nugetDeps = ./deps.json;
  rev = "03756cb5a3112fb94aeffef227ddec48db531cad";
  hash = "sha256-sZhO332seVPuYhk6Cx5UEPyGWfN9TkuavvpVyLJU2Sw=";
  projectFile = [
    "lib/cctask/CCTask_NET.sln"
    "Renode_NET.sln"
  ];
}).overrideAttrs
  (old: {
    passthru = old.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--override-filename"
          "pkgs/by-name/re/renode/package.nix"
        ];
      };
      buildRenode = args: callPackage ./common.nix args;
    };
  })
