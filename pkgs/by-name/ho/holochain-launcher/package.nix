{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  openssl,
  # webkitgtk_4_0,
  libappindicator,
  wrapGAppsHook3,
  shared-mime-info,
  glib-networking,
}:

stdenv.mkDerivation rec {
  pname = "holochain-launcher";
  version = "0.11.5";
  prerelease = "beta-2";

  src = fetchurl {
    url = "https://github.com/holochain/launcher/releases/download/v${version}/holochain-launcher-${prerelease}_${version}_amd64.deb";
    sha256 = "sha256-MRFQJRfvJ+dLmPDfPQX9wErIwEr07EAUqxic8kbKVdo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3 # required for FileChooser
  ];

  buildInputs = [
    openssl
    # webkitgtk_4_0
    libappindicator

    glib-networking
  ];

  installPhase = ''
    mv usr $out
    mv $out/bin/holochain-launcher-${prerelease} $out/bin/holochain-launcher
  '';

  preFixup = ''
    patchelf --add-needed "libappindicator3.so" "$out/bin/holochain-launcher"

    # without this the DevTools will just display an unparsed HTML file (see https://github.com/tauri-apps/tauri/issues/5711#issuecomment-1336409601)
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
  '';

  meta = with lib; {
    # webkitgtk_4_0 was removed
    broken = true;
    description = "Cross-platform executable that launches a local Holochain conductor, and installs and opens apps";
    homepage = "https://github.com/holochain/launcher";
    maintainers = [ maintainers.steveej ];
    license = licenses.cal10;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
  };
}
