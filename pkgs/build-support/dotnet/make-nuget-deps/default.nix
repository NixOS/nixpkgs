{ symlinkJoin
, fetchurl
, stdenvNoCC
, lib
, unzip
, patchNupkgs
, nugetPackageHook
}:
lib.makeOverridable(
  { name
  , nugetDeps ? import sourceFile
  , sourceFile ? null
  , installable ? false
  }:
  (symlinkJoin {
    name = "${name}-nuget-deps";
    paths = nugetDeps {
      fetchNuGet =
        { pname
        , version
        , sha256 ? ""
        , hash ? ""
        , url ? "https://www.nuget.org/api/v2/package/${pname}/${version}" }:
        stdenvNoCC.mkDerivation rec {
          inherit pname version;

          src = fetchurl {
            name = "${pname}.${version}.nupkg";
            # There is no need to verify whether both sha256 and hash are
            # valid here, because nuget-to-nix does not generate a deps.nix
            # containing both.
            inherit url sha256 hash version;
          };

          nativeBuildInputs = [
            unzip
            patchNupkgs
            nugetPackageHook
          ];

          unpackPhase = ''
            unzip -nq $src
            chmod -R +rw .
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
            dir=$out/share/nuget/packages/${lib.toLower pname}/${lib.toLower version}
            mkdir -p $dir
            cp -r . $dir
            echo {} > "$dir"/.nupkg.metadata
          '';

          preFixup = ''
            patch-nupkgs $out/share/nuget/packages
          '';

          createInstallableNugetSource = installable;
        };
    };
  }) // {
    inherit sourceFile;
  })
