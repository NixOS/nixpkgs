{
  appindicator-sharp,
  coreutils,
  fetchFromGitHub,
  git,
  git-lfs,
  glib,
  gtk-sharp-3_0,
  lib,
  makeWrapper,
  meson,
  mono,
  ninja,
  notify-sharp,
  openssh,
  openssl,
  pkg-config,
  stdenv,
  symlinkJoin,
  webkit2-sharp,
  xdg_utils,
}:

stdenv.mkDerivation rec {
  pname = "sparkleshare";
  version = "3.28";

  src = fetchFromGitHub {
    owner = "hbons";
    repo = "SparkleShare";
    rev = version;
    sha256 = "sha256:1x5nv2f3mrsr4a336bz5kc2lzkzilfh43bxy2yqhhjp2dgb20497";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    mono
    ninja
    pkg-config
  ];

  buildInputs = [
    appindicator-sharp
    gtk-sharp-3_0
    notify-sharp
    webkit2-sharp
  ];

  patchPhase = ''
    # Nix will manage the icon cache.
    echo '#!/bin/sh' >scripts/post-install.sh
  '';

  postInstall = ''
    wrapProgram $out/bin/sparkleshare \
        --set PATH ${symlinkJoin {
          name = "mono-path";
          paths = [
            coreutils
            git
            git-lfs
            glib
            mono
            openssh
            openssl
            xdg_utils
          ];
        }}/bin \
        --set MONO_GAC_PREFIX ${lib.concatStringsSep ":" [
          appindicator-sharp
          gtk-sharp-3_0
          webkit2-sharp
        ]} \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath [
          appindicator-sharp
          gtk-sharp-3_0.gtk3
          webkit2-sharp
          webkit2-sharp.webkitgtk
        ]}
  '';

  meta = {
    description = "Share and collaborate by syncing with any Git repository instantly. Linux, macOS, and Windows";
    homepage = "https://sparkleshare.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
