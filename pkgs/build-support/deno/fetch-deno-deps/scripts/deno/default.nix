{
  lib,
  makeWrapper,
  stdenvNoCC,
  deno,
}:
let
  denoJson = builtins.fromJSON (builtins.readFile ./deno.json);
in
{
  fetch-deno-deps-scripts =
    let
      scripts = {
        lockfile-transformer = "./src/lockfile-transformer/lockfile-transformer.ts";
        single-fod-fetcher = "./src/fetcher/single-fod-fetcher.ts";
        file-transformer-npm = "./src/file-transformer/file-transformer-npm.ts";
      };
      wrappers = builtins.concatStringsSep "\n" (
        builtins.attrValues (
          builtins.mapAttrs (name: path: ''
            makeWrapper "${deno}/bin/deno" $out/bin/${name} --set DENO_DIR "./.deno" --add-flags "run --allow-all $out/${path}";
          '') scripts
        )
      );
    in
    stdenvNoCC.mkDerivation {
      pname = denoJson.name;
      inherit (denoJson) version;
      src = lib.sourceFilesBySuffices ./. [ ".ts" ];
      buildPhase =
        ''
          mkdir -p $out;
          cp -r $src/* $out;
        ''
        + wrappers;
      nativeBuildInputs = [
        makeWrapper
      ];
    };
}
