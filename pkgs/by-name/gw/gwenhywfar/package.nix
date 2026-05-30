{
  lib,
  stdenv,
  fetchurl,
  gnutls,
  openssl,
  libgcrypt,
  libgpg-error,
  pkg-config,
  gettext,
  which,
  writeScript,

  # GUI support
  gtk3,
  qt5,

  pluginSearchPaths ? [
    "/run/current-system/sw/lib/gwenhywfar/plugins"
    ".nix-profile/lib/gwenhywfar/plugins"
  ],
}:

stdenv.mkDerivation rec {
  pname = "gwenhywfar";
  version = "5.14.1";
  releaseId = "630";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/gwenhywfar-${version}.tar.gz";
    hash = "sha256-iRb+qpnLlU+WPyy6jdLf/lfKz38oTa8A6rBxqtb+KrM=";
  };

  passthru = {
    updateScript = writeScript "update-gwenhywfar" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep gnused coreutils common-updater-scripts

      set -eu -o pipefail

      url="https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"

      # Extract all download paths for the tar.gz archives
      downloads=$(curl -s "$url" | grep -Po 'attachments/download/\d+/gwenhywfar-\d+\.\d+\.\d+\.tar\.gz')

      # Use version sort (-V) to find the highest version number
      latest_version=$(echo "$downloads" | grep -Po '\d+\.\d+\.\d+' | sort -V | tail -n 1)

      # Grab the exact download path for that specific highest version
      latest_download=$(echo "$downloads" | grep "gwenhywfar-$latest_version\.tar\.gz" | head -n 1)
      latest_release_id=$(echo "$latest_download" | cut -d'/' -f3)

      # Update the releaseId statically inside this nix file
      sed -i "s/releaseId = \"[0-9]\+\";/releaseId = \"$latest_release_id\";/" pkgs/by-name/gw/gwenhywfar/package.nix

      # Update the version and hash using the standard Nixpkgs tool
      update-source-version gwenhywfar "$latest_version"
    '';
  };

  configureFlags = [
    "--with-openssl-includes=${openssl.dev}/include"
    "--with-openssl-libs=${lib.getLib openssl}/lib"
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-guis=gtk3 qt5")
  '';

  postPatch =
    let
      isRelative = path: builtins.substring 0 1 path != "/";
      mkSearchPath =
        path:
        ''
          p; g; s,\<PLUGINDIR\>,"${path}",g;
        ''
        + lib.optionalString (isRelative path) ''
          s/AddPath(\(.*\));/AddRelPath(\1, GWEN_PathManager_RelModeHome);/g
        '';

    in
    ''
      sed -i -e '/GWEN_PathManager_DefinePath.*GWEN_PM_PLUGINDIR/,/^#endif/ {
        /^#if/,/^#endif/ {
          H; /^#endif/ {
            ${lib.concatMapStrings mkSearchPath pluginSearchPaths}
          }
        }
      }' src/gwenhywfar.c

      # Strip off the effective SO version from the path so that for example
      # "lib/gwenhywfar/plugins/60" becomes just "lib/gwenhywfar/plugins".
      sed -i -e '/^gwenhywfar_plugindir=/s,/\''${GWENHYWFAR_SO_EFFECTIVE},,' \
        configure
    '';

  nativeBuildInputs = [
    pkg-config
    gettext
    which
  ];

  buildInputs = [
    gtk3
    qt5.qtbase
    gnutls
    openssl
    libgcrypt
    libgpg-error
  ];

  dontWrapQtApps = true;

  meta = {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = "https://www.aquamaniac.de/rdm/projects/gwenhywfar";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
