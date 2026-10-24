{ stdenv
, dpkg
, autoPatchelfHook
, makeWrapper
, glibc
, glib
, lib
, requireFile
, libxml2
, versions ? ""
, callPackage
, ...
}:

let
  v = callPackage ../_1c-enterprise {};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "_1c-enterprise-common";
  version = v.pkgVersion;
  pkgversion = v.pkgVersionStr;
  src = requireFile v.commonDebInfo;

  nativeBuildInputs = [ dpkg autoPatchelfHook makeWrapper ];

  buildInputs = [
    stdenv.cc.cc.lib
    glibc
    glib
    libxml2
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt}
    find ./opt/1cv8 -name 'libstdc++.so.6' -delete
    find ./opt/1cv8 -name 'libstdc++.so.6.0.28' -delete
    cp -r ./opt $out
    cp -r ./usr/share $out

    runHook postInstall
  '';

  postInstall = ''
    ln -s $out/opt/1cv8/x86_64/${finalAttrs.version}/addnhost64 $out/bin/addnhost64
  '';

  meta = with lib; {
    description = "1C:Enterprise ${finalAttrs.version} common components";
    homepage = "https://1c.ru";
    license = {
      fullName = "License agreement for 1C:Enterprise 8.3";
      url = "file://${out}/opt/1cv8/x86_64/${finalAttrs.version}/licenses/1CEnterprise_en.htm";
      free = false;
    };
    platforms = [ "x86_64-linux" ];
  };
})