{ stdenv
, lib
, fetchurl
, makeWrapper
, libuuid
, libunwind
, icu
, openssl
, zlib
, curl
, at-spi2-core
, at-spi2-atk
, gnutar
, atomEnv
, kerberos
}:

# from justinwoo/azuredatastudio-nix
# https://github.com/justinwoo/azuredatastudio-nix/blob/537c48aa3981cd1a82d5d6e508ab7e7393b3d7c8/default.nix

stdenv.mkDerivation rec {

  pname = "azuredatastudio";
  version = "1.20.0";

  src = fetchurl {
    url = "https://sqlopsbuilds.azureedge.net/stable/cfbadd1eaef2dfa1fd643009c572137c704f1009/azuredatastudio-linux-${version}.tar.gz";
    sha256 = "1lbjlg5xspyq7b6nl8hq27j3bzprvk314lknd8659a6wcarm44dx";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libuuid
    at-spi2-core
    at-spi2-atk
  ];

  phases = "unpackPhase fixupPhase";

  # change this to azuredatastudio-insiders for insiders releases
  edition = "azuredatastudio";
  targetPath = "$out/${edition}";

  unpackPhase = ''
    mkdir -p ${targetPath}
    ${gnutar}/bin/tar xf $src --strip 1 -C ${targetPath}
  '';

  sqltoolsserviceRpath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    libunwind
    libuuid
    icu
    openssl
    zlib
    curl
  ];

  # this will most likely need to be updated when azuredatastudio's version changes
  sqltoolsservicePath = "${targetPath}/resources/app/extensions/mssql/sqltoolsservice/Linux/3.0.0-release.4";

  rpath = stdenv.lib.concatStringsSep ":" [
    atomEnv.libPath
    (
      stdenv.lib.makeLibraryPath [
        libuuid
        at-spi2-core
        at-spi2-atk
        stdenv.cc.cc.lib
        kerberos
      ]
    )
    targetPath
    sqltoolsserviceRpath
  ];

  fixupPhase = ''
    fix_sqltoolsservice()
    {
      mv ${sqltoolsservicePath}/$1 ${sqltoolsservicePath}/$1_old
      patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        ${sqltoolsservicePath}/$1_old

      makeWrapper \
        ${sqltoolsservicePath}/$1_old \
        ${sqltoolsservicePath}/$1 \
        --set LD_LIBRARY_PATH ${sqltoolsserviceRpath}
    }

    fix_sqltoolsservice MicrosoftSqlToolsServiceLayer
    fix_sqltoolsservice MicrosoftSqlToolsCredentials
    fix_sqltoolsservice SqlToolsResourceProviderService

    patchelf \
      --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
      ${targetPath}/${edition}

    mkdir -p $out/bin
    makeWrapper \
      ${targetPath}/bin/${edition} \
      $out/bin/azuredatastudio \
      --set LD_LIBRARY_PATH ${rpath}
    mkdir -p $out/share/applications
    ${stdenv.lib.concatStrings (map (name: ''
      substitute ${./. + "/${name}.desktop"} $out/share/applications/${name}.desktop --subst-var out
    '') [ "azuredatastudio" ])}
  '';

  meta = {
    maintainers = with stdenv.lib.maintainers; [ xavierzwirtz ];
    description = "A data management tool that enables working with SQL Server, Azure SQL DB and SQL DW";
    homepage = "https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio";
    license = lib.licenses.unfreeRedistributable;
  };
}
