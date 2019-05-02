{ stdenv
, fetchurl
, cmake
, extra-cmake-modules

# common deps
, karchive

# client deps
, qtbase
, qtmultimedia
, qtsvg
, qttools

# optional client deps
, giflib
, kdnssd
, libvpx
, miniupnpc
, qtx11extras # kis

# optional server deps
, libmicrohttpd
, libsodium

# options
, buildClient ? true
, buildServer ? true
, buildServerGui ? true # if false builds a headless server
, buildExtraTools ? false
, enableKisTablet ? false # enable improved graphics tablet support
}:

with stdenv.lib;

let
  commonDeps = [
    karchive
  ];
  clientDeps = [
    qtbase
    qtmultimedia
    qtsvg
    qttools
    # optional:
    giflib # gif animation export support
    kdnssd # local server discovery with Zeroconf
    libvpx # WebM video export
    miniupnpc # automatic port forwarding
  ];
  serverDeps = [
    # optional:
    libmicrohttpd # HTTP admin api
    libsodium # ext-auth support
  ];
  kisDeps = [
    qtx11extras
  ];

in stdenv.mkDerivation rec {
  name = "drawpile-${version}";
  version = "2.1.7";

  src = fetchurl {
    url = "https://drawpile.net/files/src/drawpile-${version}.tar.gz";
    sha256 = "1nk1rb1syrlkxq7qs101ifaf012mq42nmq1dbkssnx6niydi3bbd";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs =
    commonDeps ++
    optionals buildClient      clientDeps ++
    optionals buildServer      serverDeps ++
    optionals enableKisTablet  kisDeps    ;

  cmakeFlags =
    optional (!buildClient    )  "-DCLIENT=off" ++
    optional (!buildServer    )  "-DSERVER=off" ++
    optional (!buildServerGui )  "-DSERVERGUI=off" ++
    optional ( buildExtraTools)  "-DTOOLS=on" ++
    optional ( enableKisTablet)  "-DKIS_TABLET=on";

  meta = {
    description = "A collaborative drawing program that allows multiple users to sketch on the same canvas simultaneously";
    homepage = https://drawpile.net/;
    downloadPage = https://drawpile.net/download/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.unix;
  };
}

