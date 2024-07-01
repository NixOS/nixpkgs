{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cpio,
  gzip,
  unar,
  darwin,
  zlib,
  version,
  meta,
  pname,
}: let
  arch =
    if stdenv.isAarch64
    then "arm64"
    else "x86_64";
in
  stdenv.mkDerivation rec {
    inherit pname version meta;
    dontStrip = true;

    src = fetchurl {
      url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/${lib.versions.majorMinor version}/darwin_${arch}/snowsql-${version}-darwin_${arch}.pkg";
      sha256 =
        if arch == "arm64"
        then "acb2096b87466f0fdbff544d9f64feafc23cbee1bdf963e84b9658511ade9536"
        else "9727c07fc11b1d8adf4a4eb0b5b996d82cd3d9da191a86f4c7b772726f8e5e92";
    };

    nativeBuildInputs = [unar cpio unzip gzip zlib];

    unpackPhase = ''
      unar $src
    '';

    buildPhase = ''
      cd *snowsql-${version}-darwin_${arch}
      cat snowsql-darwin.pkg/Payload | gzip -d | cpio -idmv
      unzip SnowSQL.app/Contents/MacOS/snowsql-${version}-darwin_${arch}.zip -d zipped-content
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp -r zipped-content/* $out/bin/
    '';

    postFixup =
      if arch == "arm64"
      then ''
        install_name_tool -change /usr/lib/libSystem.B.dylib ${darwin.Libsystem}/lib/libSystem.B.dylib $out/bin/snowsql
        install_name_tool -change /usr/lib/libz.1.dylib ${zlib}/lib/libz.1.dylib $out/bin/snowsql
      ''
      else "";
  }
