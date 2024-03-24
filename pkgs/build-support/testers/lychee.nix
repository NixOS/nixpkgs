deps@{ formats, lib, lychee, stdenv }:
let

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-lycheeLinkCheck
  # or doc/builders/testers.chapter.md
  lycheeLinkCheck = {
    site,
    remapUrl ? null,
    lychee ? deps.lychee,
    extraConfig ? { },
  }:
    stdenv.mkDerivation (finalAttrs: {
      name = "lychee-link-check";
      inherit site;
      nativeBuildInputs = [ finalAttrs.passthru.lychee ];
      configFile = (formats.toml {}).generate "lychee.toml" finalAttrs.passthru.config;

      # These can be overriden with overrideAttrs if needed.
      passthru = {
        inherit lychee remapUrl;
        config = {
          include_fragments = true;
        } // lib.optionalAttrs (finalAttrs.passthru.remapUrl != null) {
          remap = [ "${remapUrl} file://${finalAttrs.site}" ];
        } // extraConfig;
      };
      buildCommand = ''
        echo Checking internal links on $site
        lychee --offline --config $configFile $site
        touch $out
      '';
    });

in
{
  inherit lycheeLinkCheck;
}
