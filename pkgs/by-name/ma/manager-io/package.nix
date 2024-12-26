{
  stdenv,
  fetchurl,
  lib,
  appimageTools,
  icu,
  webkitgtk_6_0,
  webkitgtk_4_0, # for older devices
  mono,
  libnotify,
  lttng-ust,
}:

let
  pname = "manager-io";
  version = "24.12.23.1999";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/Manager-io/Manager/releases/download/${version}/Manager-linux-x64.AppImage";
    hash = "sha256-Q4bH1cFvZfNSOWGXmg/RAOtjK6u5p2iRfUrOvetnoOs=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;

    postExtra =
      let
        libPath = lib.makeLibraryPath [
          icu
          webkitgtk_6_0
          webkitgtk_4_0 # for older devices
          mono
          libnotify
          stdenv.cc.cc
          lttng-ust
        ];

      in
      ''
        patchelf \
         --add-needed libicui18n.so \
         --add-needed libicuuc.so \
         $out/opt/manager/libcoreclr.so \
         $out/opt/manager/*System.Globalization.Native.so
        patchelf \
         --add-needed libgssapi_krb5.so \
         $out/opt/manager/*System.Net.Security.Native.so
        patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/opt/manager/libcoreclrtraceptprovider.so
        patchelf --add-needed libssl.so \
         $out/opt/manager/*System.Security.Cryptography.Native.OpenSsl.so
        patchelf \
         --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
         --set-rpath "${libPath}" \
         $out/opt/manager/ManagerDesktop
      '';
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/manager.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs = pkgs: [ 
    icu
    webkitgtk_6_0
    webkitgtk_4_0 # for older devices
    mono
    libnotify
    stdenv.cc.cc
    lttng-ust
  ];

  meta = {
    description = "Free Accounting software for Windows, Mac and Linux";
    homepage = "https://www.manager.io";
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ darwincereska ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
    ];
  };
}
