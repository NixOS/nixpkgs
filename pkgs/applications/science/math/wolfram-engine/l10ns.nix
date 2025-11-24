{
  lib,
  requireFile,
  lang,
  majorVersion ? null,
}:

let
  allVersions =
    lib.flip map
      # N.B. Versions in this list should be ordered from newest to oldest.
      [
        {
          version = "14.1.0";
          lang = "en";
          language = "English";
          sha256 = "1kxdvm3i7nn3ws784y972h2br1n0y82kkkjvz7c5llssv6d3pgj8";
          installer = "WolframEngine_14.1.0_LIN.sh";
        }
        {
          version = "13.3.0";
          lang = "en";
          language = "English";
          sha256 = "96106ac8ed6d0e221a68d846117615c14025320f927e5e0ed95b1965eda68e31";
          installer = "WolframEngine_13.3.0_LINUX.sh";
        }
        {
          version = "13.2.0";
          lang = "en";
          language = "English";
          sha256 = "1xvg1n64iq52jxnk9y551m5iwkkz6cxzwyw28h8d0kq36aaiky24";
          installer = "WolframEngine_13.2.0_LINUX.sh";
        }
        {
          version = "13.1.0";
          lang = "en";
          language = "English";
          sha256 = "1659kyp38a8xknic95pynx9fsgn96i8jn9lnk89pc8n6vydw1460";
          installer = "WolframEngine_13.1.0_LINUX.sh";
        }
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
      (
        {
          version,
          lang,
          language,
          sha256,
          installer,
        }:
        {
          inherit version lang;
          name = "wolfram-engine-${version}" + lib.optionalString (lang != "en") "-${lang}";
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
        }
      );
  minVersion =
    if majorVersion == null then
      lib.elemAt (builtins.splitVersion (lib.elemAt allVersions 0).version) 0
    else
      majorVersion;
  maxVersion = toString (1 + builtins.fromJSON minVersion);
in
lib.findFirst (
  l: (l.lang == lang && l.version >= minVersion && l.version < maxVersion)
) (throw "Version ${minVersion} in language ${lang} not supported") allVersions
