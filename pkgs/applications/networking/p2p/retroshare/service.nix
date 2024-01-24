{ lib
, stdenv
, callPackage
, cmake
, doxygen
, git
, pkg-config
, python3
, bzip2
, libzip
, miniupnpc
, openssl
, rapidjson
, sqlcipher
, xapian
, enableWebUI ? true
}:
let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation rec {
  pname = "retroshare-service";

  inherit (common) version src;

  patches = [
    ./fix-webui-path.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    git
    pkg-config
    python3
  ];

  buildInputs = [
    bzip2
    libzip
    miniupnpc
    openssl
    rapidjson
    sqlcipher
    xapian
  ];

  preConfigure = ''
    patchShebangs retroshare-webui/webui-src/make-src/build.sh
    cd retroshare-service
  '';

  cmakeFlags = builtins.map (fl: "-D" + fl) common.RSVersionFlags
  ++ [
    "-DRS_FORUM_DEEP_INDEX=ON"
  ] ++ lib.optionals enableWebUI [
    "-DRS_JSON_API=ON"
    "-DRS_SERVICE_TERMINAL_WEBUI_PASSWORD=ON"
    "-DRS_WEBUI=ON"
  ];

  meta = with lib; {
    description = "Headless retroshare node";
    homepage = "https://retroshare.cc/";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW dandellion];
  };
}
