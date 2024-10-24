{
  fetchurl,
  stdenv,
  system,
  zstd,
  webkitgtk,
  libappindicator,
  gtk3,
  cairo,
  gdk-pixbuf,
  libsoup,
  glib,
  autoPatchelfHook,
  makeDesktopItem,
}:
let
  desktop = makeDesktopItem {
    name = "GlobalProtect Openconnect VPN Client";
    desktopName = "GlobalProtect Openconnect VPN Client";
    comment = "A GUI for GlobalProtect VPN";
    genericName = "GlobalProtect VPN Client";
    exec = "gpclient launch-gui %u";
    icon = "gpgui";
    categories = [
      "Network"
      "Dialup"
    ];
    mimeTypes = [ "x-scheme-handler/globalprotectcallback" ];
  };

  version = "2.3.7";
  remoteHashes = {
    "x86_64-linux" = {
      sha256 = "sha256-o1jTVfIzKk19uJH+NKFUL+Vjdlo/yZ7c44vCnv+FEfc=";
      arch-name = "x86_64";
    };
    "aarch64-linux" = {
      sha256 = "sha256-DibtaY8/h11/V78a/A46Nnku8TqMLcZ0OPr0mzV4xkc=";
      arch-name = "aarch64";
    };
  };

  remotes = builtins.mapAttrs (
    _:
    { sha256, arch-name }:
    fetchurl {
      inherit sha256;
      url = "https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${version}/globalprotect-openconnect-${version}-1-${arch-name}.pkg.tar.zst";
    }
  ) remoteHashes;

in
stdenv.mkDerivation {
  name = "gpgui";
  inherit version;
  src = remotes.${system};
  nativeBuildInputs = [
    zstd
    webkitgtk
    autoPatchelfHook
    libappindicator
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    libsoup
    glib
  ];
  postUnpack = ''
    tar xf $src
  '';

  postPatch = ''
    sed -i 's/\/usr\/bin\/gpservice/gpservice/' ./share/polkit-1/actions/com.yuezk.gpgui.policy
  '';

  postInstall = ''
    mkdir -p $out/bin/
    install -m 0755 ./bin/gpgui $out/bin/
    patchelf \
        --add-needed libappindicator3.so.1 \
        $out/bin/gpgui
    mkdir -p $out/share/
    ln -s ${desktop}/share/applications/ $out/share/applications
    cp -r share/icons/ $out/share/
    cp -r share/polkit-1/ $out/share/
  '';
}
