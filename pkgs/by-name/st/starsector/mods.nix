{
  lib,
  stdenvNoCC,
  fetchzip,
  runCommand,
  dos2unix,
  jq,
  p7zip,
  starsector,
  unrar,
}:

let
  semiOptionalInput =
    str: bool: "mkStarsectorMod needs an '${str}' attribute, or 'isStandardSrc' set to '${bool}'.";
  mkStarsectorMod =
    {
      pname,
      version,
      id,
      isStandardSrc ? true,
      src ? if isStandardSrc then "" else throw (semiOptionalInput "src" "true"),
      url ? if !isStandardSrc then "" else throw (semiOptionalInput "url" "false"),
      hash ? if !isStandardSrc then "" else throw (semiOptionalInput "hash" "false"),
      stripRoot ? true,
      author ? "",
      prettyName ? "",
      summary ? "",
      description ? "",
      forumURL ? "",
      ...
    }@args:

    stdenvNoCC.mkDerivation (
      finalAttrs:
      {
        inherit version pname;

        src =
          if isStandardSrc then
            fetchzip {
              pname = "source-" + pname;
              inherit
                version
                url
                hash
                stripRoot
                ;
              nativeBuildInputs =
                lib.optional (lib.hasSuffix ".rar" url) unrar
                ++ lib.optional (lib.hasSuffix ".7z" url) p7zip;
              extension =
                if (!lib.hasSuffix ".zip" url && !lib.hasSuffix ".rar" url && !lib.hasSuffix ".7z" url) then
                  "zip"
                else
                  null;
            }
          else
            src;

        dontConfigure = true;
        dontBuild = true;

        installPhase = "mkdir $out && cp -prvd * $out";

        passthru = {
          inherit
            author
            prettyName
            forumURL
            id
            ;
          tests = {
            gameVersionMatches =
              runCommand "${finalAttrs.pname}-gameVersionMatchTest"
                {
                  nativeBuildInputs = [
                    jq
                    dos2unix
                  ];
                }
                ''
                  dos2unix ${finalAttrs.finalPackage}/mod_info.json
                  modVersion="$(jq -n -f ${finalAttrs.finalPackage}/mod_info.json | jq -cMj .gameVersion)"
                  gameVersion="${starsector.version}"
                  if [ "$gameVersion" = "$modVersion" ]; then
                    echo "Mod version matches!" && echo "Success: ${finalAttrs.pname}" >> $out
                  else
                    echo "Mod version did not match! Tried comparing '$gameVersion' to '$modVersion'."
                    exit 1
                  fi
                '';
          };
        };

        meta = {
          description = "Starsector Mod: ${prettyName}";
          longDescription =
            (if (lib.hasPrefix summary description) then description else "${summary}\n${description}")
            + "\n- by ${author}.";
          homepage = forumURL;
          sourceProvenance = lib.optional (lib.pathIsDirectory (
            finalAttrs.src + "/jars"
          )) lib.sourceTypes.binaryBytecode;
          inherit (starsector.meta)
            license
            maintainers
            platforms
            badPlatforms
            ;
        };
      }
      // args
    );
in
{
  inherit mkStarsectorMod;
}

# TODO: Somehow parse the very non-standard mess that are
# Starsector mods. There are mod packages that include two mods
# in a single zip, some mods just straight up use invalid JSON,
# while others can only be accessed through impermanent source
# directories and/or lack a versioned URL. Oh, did I mention the
# lack of consistent line endings?
