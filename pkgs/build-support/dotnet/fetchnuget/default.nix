{ fetchurl, buildDotnetPackage, unzip }:

attrs @
{ pname
, version
, url ? "https://www.nuget.org/api/v2/package/${pname}/${version}"
, sha256 ? ""
, md5 ? ""
, ...
}:
if md5 != "" then
  throw "fetchnuget does not support md5 anymore, please use sha256"
else
  buildDotnetPackage ({
    src = fetchurl {
      inherit url sha256;
      name = "${pname}.${version}.zip";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ unzip ];

    dontBuild = true;

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
