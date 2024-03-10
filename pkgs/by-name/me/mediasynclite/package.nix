{ pkgs
, lib
}:

pkgs.stdenv.mkDerivation rec {
  pname = "mediasynclite";
  version = "0.4.2";

  src = pkgs.fetchgit {
    url = "https://github.com/tobz619/MediaSyncLiteLinuxNix.git";
    sha256 = "0qikr04nw9jkl3r7z0l9s3qy1p6h5ngln0lqmw023dbf6vmrwbcr";
    };

  buildInputs = with pkgs; [
   gtk3
   glib
   gsettings-desktop-schemas
   pkg-config
   curl
   openssl.dev
   jansson
   wrapGAppsHook
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  prePatch = ''
    substituteAllInPlace ./src/ibmsl.c
    '';

  meta = with lib; {
    description = "A Linux-native graphical uploader for iBroadcast";
    downloadPage = https://github.com/tobz619/MediaSyncLiteLinuxNix;
    homepage = https://github.com/iBroadcastMediaServices/MediaSyncLiteLinux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tobz619 ];
  };
}
