{ renode
, fetchurl
, writeScript
}:

renode.overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.15.0+20240426git72f3c383b";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-BOQT5nG6Vu12RyAkCwnh6PYfNQTcYGdV4XHDpi/8kPE=";
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
          | egrep 'renode-${versionRegex}\.linux-portable\.tar\.gz' \
          | head -n1 \
          | sed -e 's,renode-\(.*\)\.linux-portable\.tar\.gz,\1,g'
      )

      update-source-version ${finalAttrs.pname} "$latestVersion" \
        --file=pkgs/by-name/re/${finalAttrs.pname}/package.nix \
        --system=x86_64-linux
    '';
})
