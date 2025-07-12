{
  lib,
  writeTextFile,
  callPackage,
  nodejs_24,
  stdenvNoCC,
}:
let
  inherit (callPackage ../deno-cache-dir-wrapper { }) deno-cache-dir-wrapper;

  makeUrlFileMapJson =
    { allFiles }:
    let
      partitionByHasDerivation = builtins.partition (file: file ? derivation) allFiles;
      filesWithDerivation = partitionByHasDerivation.right;
      filesWithoutDerivation = partitionByHasDerivation.wrong;

      urlFileMap = builtins.map (
        { url, outPath, ... }@file:
        let
          lines = lib.splitString "\r" (builtins.readFile "${outPath}-headers");
          lines' = builtins.map lib.strings.trim (builtins.filter (line: line != "" && line != "\n") lines);
          headers = builtins.listToAttrs (
            builtins.map (
              line:
              let
                keyValue = lib.splitString ": " line;
                keyValue' =
                  assert (builtins.length keyValue) == 2;
                  keyValue;
              in
              {
                name = builtins.elemAt keyValue' 0;
                value = builtins.elemAt keyValue' 1;
              }
            ) lines'
          );
        in
        {
          inherit headers;
          url = if file ? meta.original then file.meta.original.url else url;
          out_path = outPath; # using `outPath` makes builtins.toJSON think it's a derivation
        }
      ) filesWithoutDerivation;

      rest = builtins.map (
        { url, outPath, ... }@args:
        {
          url = if args ? meta.original then args.meta.original.url else url;
          out_path = outPath;
        }
      ) filesWithDerivation;
    in
    writeTextFile {
      name = "url-file-map.json";
      text = builtins.toJSON (urlFileMap ++ rest);
    };

  transformPackages =
    {
      urlFileMap,
      vendorDir,
      denoDir,
    }:
    stdenvNoCC.mkDerivation {
      pname = "transform-files-jsr-and-https";
      version = "0.1.0";

      src = null;
      unpackPhase = "true";

      buildPhase = ''
        mkdir -p $out/${denoDir}
        mkdir -p $out/${vendorDir}
        deno-cache-dir-wrapper --cache-path $out/${denoDir} --vendor-path $out/${vendorDir} --url-file-map ${urlFileMap}
      '';

      nativeBuildInputs = [
        nodejs_24
        deno-cache-dir-wrapper
      ];
    };
in
{
  inherit transformPackages makeUrlFileMapJson;
  transformJsrAndHttpsPackages =
    {
      allFiles,
      vendorDir,
      denoDir,
    }:
    rec {
      urlFileMap = makeUrlFileMapJson { inherit allFiles; };
      transformed = transformPackages { inherit urlFileMap vendorDir denoDir; };
    };
}
