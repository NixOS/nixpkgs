{
  symlinkJoin,
  fetchurl,
  stdenvNoCC,
  lib,
  zip,
  unzip,
  patchNupkgs,
  nugetPackageHook,
  callPackage,
  overrides ? callPackage ./overrides.nix { },
}:
{
  pname,
  version,
  sha256 ? "",
  hash ? "",
  url ? "https://www.nuget.org/api/v2/package/${pname}/${version}",
  urls ? null,
  installable ? false,
  removeSignature ? false,
}:
let
  package = stdenvNoCC.mkDerivation rec {
    inherit pname version;

    src =
      let
        urls' = if urls != null then urls else [ url ];
      in
      fetchurl (
        {
          name = "${pname}.${version}.nupkg";
          # There is no need to verify whether both sha256 and hash are
          # valid here, because nuget-to-nix does not generate a deps.nix
          # containing both.
          inherit
            sha256
            hash
            version
            ;
          urls = urls';

        }
        // (lib.optionalAttrs removeSignature {
          downloadToTemp = true;
          postFetch = ''
            mv $downloadedFile file.zip
            ${zip}/bin/zip -d file.zip ".signature.p7s"
            mv file.zip $out
          '';
        })
      );

    nativeBuildInputs = [
      unzip
      patchNupkgs
      nugetPackageHook
    ];

    unpackPhase = ''
      runHook preUnpack

      unpackNupkg "$src" source
      cd source

      runHook postUnpack
    '';

    prePatch = ''
      shopt -s nullglob
      local dir
      for dir in tools runtimes/*/native; do
        [[ ! -d "$dir" ]] || chmod -R +x "$dir"
      done
      rm -rf .signature.p7s
    '';

    installPhase = ''
      runHook preInstall

      dir=$out/share/nuget/packages/${lib.toLower pname}/${lib.toLower version}
      mkdir -p $dir
      cp -r . $dir
      echo {} > "$dir"/.nupkg.metadata

      runHook postInstall
    '';

    preFixup = ''
      patch-nupkgs $out/share/nuget/packages
    '';

    createInstallableNugetSource = installable;

    meta = {
      sourceProvenance = with lib.sourceTypes; [
        binaryBytecode
        binaryNativeCode
      ];
    };
  };
in
overrides.${pname} or lib.id package
