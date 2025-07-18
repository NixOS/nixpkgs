{
  callPackage,
  dotnet-runtime_8,
  dotnet-sdk_6,
  nix-update-script,
  renode,
  ...
}:
(renode.buildRenode {
  dotnet-sdk = dotnet-sdk_6;
  dotnet-runtime = dotnet-runtime_8;
  version = "1.15.3-unstable-2025-07-18";
  nugetDeps = ./deps.json;
  rev = "2309db7fdb58e8d9d906ed9000dbd08bbcbdae4e";
  hash = "sha256-et0W0BZ5c+Dwu8FAbiDDdHFi14oy40UTcDL6F0kmTZk=";
  projectFile = "Renode_NET.sln";
}).overrideAttrs
  (old: rec {
    postPatch = ''
      ${old.postPatch}

      # To fix value "" error in element <Import>
      rm -rf src/Directory.Build.targets
    '';

    buildInputs = old.buildInputs ++ [ passthru.deps.tlib ];

    preBuild = ''
      ${old.preBuild}

      mkdir -p src/Infrastructure/src/Emulator/Cores/bin/Release/lib
      ln -s ${passthru.deps.tlib}/lib/*.so src/Infrastructure/src/Emulator/Cores/bin/Release/lib
    '';

    passthru = old.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--version=branch"
          "--override-filename"
          "pkgs/by-name/re/renode-unstable/package.nix"
        ];
      };
      deps.tlib = callPackage ./tlib.nix { };
    };
  })
