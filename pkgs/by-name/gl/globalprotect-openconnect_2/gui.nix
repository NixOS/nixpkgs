{
  fetchurl,
  stdenv,
  zstd,
  webkitgtk_4_0,
  libappindicator,
  gtk3,
  cairo,
  gdk-pixbuf,
  libsoup,
  glib,
  autoPatchelfHook,
  version,
  lib,
  platforms,
  maintainers,
}:
let
  remoteHashes = {
    "x86_64-linux" = {
      hash = "sha256-wSoBvHkLbf9aaFWBJMfm7Angd/PwKzNH+yqvYxhjmxY=";
      arch-name = "x86_64";
    };
    "aarch64-linux" = {
      hash = "sha256-Gata5OVlckfcy/F+UBe2FW7OwB47efw69lMAAU8Q4JQ=";
      arch-name = "aarch64";
    };
  };

  remotes = builtins.mapAttrs (
    _:
    { hash, arch-name }:
    fetchurl {
      inherit hash;
      url = "https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${version}/globalprotect-openconnect-${version}-1-${arch-name}.pkg.tar.zst";
    }
  ) remoteHashes;

  src =
    if builtins.elem stdenv.hostPlatform.system (builtins.attrNames remoteHashes) then
      remotes.${stdenv.hostPlatform.system}
    else
      throw "Unsupported system '${stdenv.hostPlatform.system}'";

in
stdenv.mkDerivation {
  name = "gpgui";
  inherit version src;

  nativeBuildInputs = [
    zstd
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_0
    libappindicator
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
    substituteInPlace ./share/polkit-1/actions/com.yuezk.gpgui.policy \
      --replace-fail /usr/bin/gpservice gpservice
  '';

  postInstall = ''
    mkdir -p $out/bin/
    install -m 0755 ./bin/gpgui $out/bin/
    patchelf \
      --add-needed libappindicator3.so.1 \
      $out/bin/gpgui
    mkdir -p $out/share/
    cp -r share/icons/ $out/share/
    cp -r share/polkit-1/ $out/share/
  '';

  meta = {
    mainProgram = "gpgui";
    description = "The gui for globalprotect-openconnect_2";
    license = lib.licenses.unfree;
    inherit platforms maintainers;
  };
}
