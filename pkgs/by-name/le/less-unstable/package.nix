{
  fetchurl,
  less,
  lib,
  nix-update-script,
}:

less.overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "${less.pname}-unstable";
    version = "712";

    src = fetchurl {
      url = "https://www.greenwoodsoftware.com/less/less-${finalAttrs.version}-beta.tar.gz";
      hash = "sha256-1RyH2xs8euZXax7UAFgbxzYdNnegCbnCQTM7JgUG8BE=";
    };

    __structuredAttrs = true;

    passthru = prevAttrs.passthru or { } // {
      updateScript = nix-update-script {
        extraArgs = [
          "--url"
          "https://github.com/gwsw/less"
          "--version-regex"
          "^v([0-9]+)$"
        ];
      };
    };

    meta = prevAttrs.meta // {
      description = "More advanced file pager than 'more' (beta release)";
      changelog = "https://github.com/gwsw/less/blob/v${finalAttrs.version}/NEWS";
      maintainers = with lib.maintainers; [ yiyu ];
    };
  }
)
