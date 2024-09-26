{ renode
, fetchurl
, writeScript
}:

renode.overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.15.2+20240914gitcb658f346";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-dotnet.tar.gz";
    hash = "sha256-DkS635epflnbjYc/y4IgGgrIkRHKtuKxtebH6kdRYTw=";
  };

  passthru.updateScript =
    let
      versionRegex = "[0-9\.\+]+[^\+]*.";
    in
    writeScript "${finalAttrs.pname}-updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts curl gnugrep gnused pup

      latestVersion=$(
        curl -sS https://builds.renode.io \
          | pup 'a text{}' \
          | egrep 'renode-${versionRegex}\.linux-dotnet\.tar\.gz' \
          | head -n1 \
          | sed -e 's,renode-\(.*\)\.linux-dotnet\.tar\.gz,\1,g'
      )

      update-source-version ${finalAttrs.pname} "$latestVersion" \
        --file=pkgs/by-name/re/${finalAttrs.pname}/package.nix \
        --system=x86_64-linux
    '';
})
