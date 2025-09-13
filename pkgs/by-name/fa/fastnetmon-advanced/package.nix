{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bzip2,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fastnetmon-advanced";
  version = "2.0.372";

  src = fetchurl {
    url = "https://repo.fastnetmon.com/fastnetmon_ubuntu_jammy/pool/fastnetmon/f/fastnetmon/fastnetmon_${version}_amd64.deb";
    hash = "sha256-FwYAbTBkk+AciDVxTIimswsB0M3gbzKX+03PD0fLMsY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    bzip2
  ];

  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz

    # unused libraries, which have additional dependencies
    rm opt/fastnetmon/libraries/gcc1210/lib/libgccjit.so*
  '';

  installPhase = ''
    mkdir -p $out/libexec/fastnetmon
    cp -r opt/fastnetmon/app/bin $out/bin
    cp -r opt/fastnetmon/libraries $out/libexec/fastnetmon

    readlink usr/sbin/gobgpd
    readlink usr/bin/gobgp

    ln -s $(readlink usr/sbin/gobgpd | sed "s:/opt/fastnetmon:$out/libexec/fastnetmon:") $out/bin/fnm-gobgpd
    ln -s $(readlink usr/bin/gobgp | sed "s:/opt/fastnetmon:$out/libexec/fastnetmon:") $out/bin/fnm-gobgp

    addAutoPatchelfSearchPath $out/libexec/fastnetmon/libraries
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    set +o pipefail
    $out/bin/fastnetmon 2>&1 | grep "Can't open log file"
    $out/bin/fcli 2>&1 | grep "Please run this tool with root rights"
    $out/bin/fnm-gobgp --help 2>&1 | grep "Available Commands"
    $out/bin/fnm-gobgpd --help 2>&1 | grep "Application Options"
  '';

  passthru.tests = { inherit (nixosTests) fastnetmon-advanced; };

  meta = {
    description = "High performance DDoS detector / sensor - commercial edition";
    homepage = "https://fastnetmon.com";
    changelog = "https://github.com/FastNetMon/fastnetmon-advanced-releases/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    teams = [ lib.teams.wdz ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
