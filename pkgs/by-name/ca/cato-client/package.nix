{
  stdenv,
  fetchurl,
  writeScript,
  autoPatchelfHook,
  dpkg,
  libz,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "cato-client";
  version = "5.5.0.2620";

  src = fetchurl {
    url = "https://clients.catonetworks.com/linux/${version}/cato-client-install.deb";
    sha256 = "sha256-V1BhgLOHP/pGlwvjVFdNslKupjHBVSTDVIRtZ6amwbk=";
  };

  passthru.updateScript = writeScript "update-cato-client" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre2 common-updater-scripts

    set -eu -o pipefail

    version="$(curl -sI https://clientdownload.catonetworks.com/public/clients/cato-client-install.deb | grep -Fi 'Location:' | pcre2grep -o1 '/(([0-9]\.?)+)/')"
    update-source-version cato-client "$version"
  '';

  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    libz
    stdenv.cc.cc
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src source
    cd source
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out

    mv usr/lib $out/lib

    mkdir -p $out/bin
    mv usr/sbin/* $out/bin
    mv usr/bin/* $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Lightweight agent that provides secure zero-trust access to resources everywhere";
    homepage = "https://www.catonetworks.com/platform/cato-client/";
    mainProgram = "cato-sdp";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ yarekt ];
    platforms = [ "x86_64-linux" ];
  };
}
