{ stdenv
, lib
, fetchurl
, makeWrapper
, libuuid
, libunwind
, libxkbcommon
, icu
, openssl
, zlib
, curl
, at-spi2-core
, at-spi2-atk
, gnutar
, atomEnv
, libkrb5
, libdrm
, mesa
, xorg
}:

# from justinwoo/azuredatastudio-nix
# https://github.com/justinwoo/azuredatastudio-nix/blob/537c48aa3981cd1a82d5d6e508ab7e7393b3d7c8/default.nix

stdenv.mkDerivation rec {

  pname = "azuredatastudio";
  version = "1.33.0";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://azuredatastudio-update.azurewebsites.net/${version}/linux-x64/stable";
    sha256 = "0593xs44ryfyxy0hc31hdbj706q16h58jb0qyfyncn7ngybm3423";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libuuid
    at-spi2-core
    at-spi2-atk
  ];

  dontInstall = true;

  # change this to azuredatastudio-insiders for insiders releases
  edition = "azuredatastudio";
  targetPath = "$out/${edition}";

  unpackPhase = ''
    mkdir -p ${targetPath}
    ${gnutar}/bin/tar xf $src --strip 1 -C ${targetPath}
  '';

  sqltoolsserviceRpath = lib.makeLibraryPath [
    stdenv.cc.cc
    libunwind
    libuuid
    icu
    openssl
    zlib
    curl
  ];

  # this will most likely need to be updated when azuredatastudio's version changes
  sqltoolsservicePath = "${targetPath}/resources/app/extensions/mssql/sqltoolsservice/Linux/3.0.0-release.139";

  rpath = lib.concatStringsSep ":" [
    atomEnv.libPath
    (
      lib.makeLibraryPath [
        libuuid
        at-spi2-core
        at-spi2-atk
        stdenv.cc.cc.lib
        libkrb5
        libdrm
        libxkbcommon
        mesa
        xorg.libxshmfence
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
  '';

  meta = {
    maintainers = with lib.maintainers; [ xavierzwirtz ];
    description = "A data management tool that enables working with SQL Server, Azure SQL DB and SQL DW";
    homepage = "https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
