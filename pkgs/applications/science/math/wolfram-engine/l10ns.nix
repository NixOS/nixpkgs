{ lib
, requireFile
, lang
, majorVersion ? null
}:

let allVersions = with lib; flip map
  # N.B. Versions in this list should be ordered from newest to oldest.
  [
    {
      version = "13.0.1";
      lang = "en";
      language = "English";
      sha256 = "1rrxi7d51m02407k719fq829jzanh550wr810i22n3irhk8axqga";
      installer = "WolframEngine_13.0.1_LINUX.sh";
    }
    {
      version = "13.0.0";
      lang = "en";
      language = "English";
      sha256 = "10cpwllz9plxz22iqdh6xgkxqphl9s9nq8ax16pafjll6j9kqy1q";
      installer = "WolframEngine_13.0.0_LINUX.sh";
    }
  ]
  ({ version, lang, language, sha256, installer }: {
    inherit version lang;
    name = "wolfram-engine-${version}" + optionalString (lang != "en") "-${lang}";
    src = requireFile {
      name = installer;
      message = ''
        This nix expression requires that ${installer} is
        already part of the store. Download the file from
        https://www.wolfram.com/engine/ and add it to the nix store
        with nix-store --add-fixed sha256 <FILE>.
      '';
      inherit sha256;
    };
  });
minVersion =
  with lib;
  if majorVersion == null
  then elemAt (builtins.splitVersion (elemAt allVersions 0).version) 0
  else majorVersion;
maxVersion = toString (1 + builtins.fromJSON minVersion);
in
with lib;
findFirst (l: (l.lang == lang
               && l.version >= minVersion
               && l.version < maxVersion))
          (throw "Version ${minVersion} in language ${lang} not supported")
          allVersions
