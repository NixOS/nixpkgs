#TODO LIST:
#1. Add systemd and 1cv8usr:1cv8grp for _1c-enterprise-server
{ stdenv
, dpkg
, autoPatchelfHook
, makeWrapper
, _1c-enterprise-common
, requireFile
, glib
, glibc
, lib
, e2fsprogs
, krb5
, libssh
, unixODBC
, patchelf
, versions ? ""
, callPackage
, ...
}:

let
  v = callPackage ../_1c-enterprise {};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "_1c-enterprise-server";
  version = v.pkgVersion;
  pkgversion = v.pkgVersionStr;
  src = requireFile v.serverDebInfo;

  nativeBuildInputs = [ dpkg patchelf autoPatchelfHook makeWrapper ];

  buildInputs = [
    _1c-enterprise-common
    stdenv.cc.cc.lib
    glibc
    e2fsprogs
    krb5
    glib
    libssh
    unixODBC
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

#    ln -sf ${_1c-enterprise-common}/opt/1cv8/x86_64/${finalAttrs.version}/*.so       $out/opt/1cv8/x86_64/${finalAttrs.version}/
#    ln -sf ${_1c-enterprise-common}/opt/1cv8/x86_64/${finalAttrs.version}/lib*       $out/opt/1cv8/x86_64/${finalAttrs.version}/

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,share/applications}
    find ./opt/1cv8 -name 'libcairo-v8.so' -delete
    cp -r ./opt $out
    cp -r ./usr/share $out

    ln -s ${_1c-enterprise-common}/opt/1cv8/x86_64/${finalAttrs.version}/* $out/opt/1cv8/x86_64/${finalAttrs.version}/

    runHook postInstall
  '';

  postInstall = ''
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/ci     $out/bin/ci
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/dbda   $out/bin/dbda
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/dbgs   $out/bin/dbgs
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/ibcmd  $out/bin/ibcmd
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/ibsrv  $out/bin/ibsrv
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/rac    $out/bin/rac
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/ragent $out/bin/ragent
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/ras    $out/bin/ras
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/rmngr  $out/bin/rmngr
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/rmstt  $out/bin/rmstt
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/rphost $out/bin/rphost
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/opt/1cv8/x86_64/${finalAttrs.version}"
    autoPatchelf $out
  '';

  meta = with lib; {
    description = "1C:Enterprise ${finalAttrs.version} server";
    homepage = "https://1c.ru";
    license = {
      fullName = "License agreement for 1C:Enterprise 8.3";
      url = "file://${out}/opt/1cv8/x86_64/${finalAttrs.version}/licenses/1CEnterprise_en.htm";
      free = false;
    };
    platforms = [ "x86_64-linux" ];
  };
})