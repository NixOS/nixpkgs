{ dpkg, fetchurl, makeWrapper, perl, stdenv }:

let
  perlEnv = perl.withPackages (p: with p; [
    CarpClan
    ClassLoad
    ClassLoadXS
    ClassMethodMaker
    ConfigIniFiles
    DataOptList
    DateCalc
    DBDSQLite
    DBI
    DevelGlobalDestruction
    DevelOverloadInfo
    EncodeLocale
    EvalClosure
    ExporterTiny
    FileSlurp
    HTMLForm
    HTMLParser
    HTMLTagset
    HTTPCookies
    HTTPDate
    HTTPMessage
    IPCSystemSimple
    JSON
    JSONXS
    ListMoreUtils
    LWP
    LWPProtocolHttps
    ModernPerl
    ModuleImplementation
    ModuleRuntime
    Moose
    MROCompat
    PackageDeprecationManager
    PackageStash
    ParamsUtil
    SubExporter
    SubExporterProgressive
    SubIdentify
    SubInstall
    SubName
    TermProgressBar
    TermReadKey
    TermReadLineGnu
    TimeDate
    TryTiny
    URI
    WWWMechanize
    XMLLibXML
    XMLSAXBase
  ]);
in

stdenv.mkDerivation rec {
  pname = "tks";
  version = "1.0.32";

  src = fetchurl {
    url = "https://debian.catalyst.net.nz/catalyst/dists/stable/catalyst/binary-amd64/tks_${version}_all.deb";
    sha256 = "b4e288fd1068adbe0cbef12e0a916df20a785d90f7773e862b3c9f3b9528afb6";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  buildInputs = [ perlEnv ];

  unpackPhase = "dpkg-deb -x ${src} .";

  preConfigure = ''
    patchShebangs usr/bin/*
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/${perl.libPrefix}

    cp -r usr/bin $out/
    cp -r usr/share/perl5/TKS $out/${perl.libPrefix}

    sed -i "s|.\+bin/perl|#!${perlEnv}/bin/perl -I $out/${perl.libPrefix}|" $out/bin/*
    sed -i "s|/usr/bin|$out/bin|g" $out/bin/*

    runHook postInstall
  '';

  meta = {
    description = "Timekeeping sucks, TKS makes it suck less";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.l0b0 ];
  };
}
