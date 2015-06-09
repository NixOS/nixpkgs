{ stdenv, fetchurl, buildDotnetPackage, unzip }:

attrs @
{ baseName
, version
, url ? "https://www.nuget.org/api/v2/package/${baseName}/${version}"
, sha256 ? ""
, md5 ? ""
, ...
}:
  buildDotnetPackage ({
    src = fetchurl {
      inherit url sha256 md5;
      name = "${baseName}.${version}.zip";
    };

    sourceRoot = ".";

    buildInputs = [ unzip ];

    phases = [ "unpackPhase" "installPhase" ];

    preInstall = ''
      function traverseRename () {
        for e in *
        do
          t="$(echo "$e" | sed -e "s/%20/\ /g" -e "s/%2B/+/g")"
          [ "$t" != "$e" ] && mv -vn "$e" "$t"
          if [ -d "$t" ]
          then
            cd "$t"
            traverseRename
            cd ..
          fi
        done
      }

      traverseRename
   '';
  } // attrs)
