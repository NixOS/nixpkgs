{ lib 
, stdenv
, fetchFromGitHub
, gtk3
, glib
, gsettings-desktop-schemas
, pkg-config
, curl
, openssl
, jansson
, wrapGAppsHook
}: 

stdenv.mkDerivation rec {
  pname = "mediasynclite";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "iBroadcastMediaServices";
    repo = "MediaSyncLiteLinux";
    rev = "d0d5caa2a1bb260f8081e4cf49cb0219b123f682";
    hash = "sha256-mS2e6zZutSEAr5gCS58t0Nzg8dCJgn/yoFMmbgnIM2I=";
    };

  buildInputs = [
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
    downloadPage = "https://github.com/tobz619/MediaSyncLiteLinuxNix";
    homepage = "https://github.com/iBroadcastMediaServices/MediaSyncLiteLinux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tobz619 ];
  };
}
