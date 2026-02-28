{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPypi,
  python3,
  makeWrapper,
  nixosTests,
}:

let
  octowebsocket-client = python3.pkgs.buildPythonPackage rec {
    pname = "octowebsocket-client";
    version = "1.8.3";
    format = "setuptools";

    src = fetchPypi {
      pname = "octowebsocket_client";
      inherit version;
      hash = "sha256-3oW25Mg1tm/N7D9qjHI7+6E3jR6bIWqYjqyvDyqP0jA=";
    };

    doCheck = false;

    meta = {
      description = "WebSocket client fork for OctoApp with CPU optimizations";
      homepage = "https://github.com/OctoEverywhere/octowebsocket-client";
      license = lib.licenses.asl20;
    };
  };

  octoflatbuffers = python3.pkgs.buildPythonPackage rec {
    pname = "octoflatbuffers";
    version = "24.3.27";
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-5l3eWw73ZmWlek0JsYeZEiOTEuogPICF/THXzE4LFN4=";
    };

    doCheck = false;

    meta = {
      description = "FlatBuffers serialization fork for OctoApp";
      homepage = "https://pypi.org/project/octoflatbuffers/";
      license = lib.licenses.asl20;
    };
  };

  pythonEnv = python3.withPackages (ps: [
    octowebsocket-client
    octoflatbuffers
    ps.requests
    ps.pillow
    ps.certifi
    ps.rsa
    ps.dnspython
    ps.httpx
    ps.urllib3
    ps.typing-extensions
    ps.configparser
    ps.qrcode
    ps.pycryptodome
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "octoapp";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "crysxd";
    repo = "OctoApp-Plugin";
    rev = "17dfd704160be61d0a53bf3ad3e366d376bb3cd6";
    hash = "sha256-pX0F5tPAbCsMP583WQux6xwRuI0Xy/Ch225G/TqWOlk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/octoapp
    cp -r moonraker_octoapp $out/lib/octoapp/
    cp -r octoapp $out/lib/octoapp/
    cp -r linux_host $out/lib/octoapp/

    mkdir -p $out/bin
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/octoapp \
      --add-flags "-m moonraker_octoapp" \
      --set PYTHONPATH "$out/lib/octoapp"

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) octoapp;
  };

  meta = {
    description = "Companion service for Klipper/Moonraker providing push notifications and remote monitoring via the OctoApp mobile app";
    homepage = "https://github.com/crysxd/OctoApp-Plugin";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
    mainProgram = "octoapp";
  };
}
