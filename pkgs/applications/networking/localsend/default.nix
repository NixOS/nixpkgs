{ pkgs, lib, flutter37, fetchFromGitHub }:

flutter37.buildFlutterApplication rec {
  pname = "localsend";
  version = "v1.10.0";

  buildInputs = with pkgs; [
    ayatana-ido
    libayatana-appindicator
    libayatana-indicator
    libdbusmenu
    libepoxy
  ];

  src = fetchFromGitHub {
    owner = "localsend";
    repo = "localsend";
    rev = version;
    sha256 = "sha256-yrUUUZU5Yzb8iDXxbxSGow9CEER20ZKy0KcbrrjgbTg=";
    fetchSubmodules = true;
  };


  #pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-ikA5b7Epdpka4/Rlkobql/X9PvYaxqnsuPbq+Vps4BM=";

  
  meta = with lib; {
    description = "An open source cross-platform alternative to AirDrop";
    homepage = "https://localsend.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = lib.platforms.all;
  };
}
