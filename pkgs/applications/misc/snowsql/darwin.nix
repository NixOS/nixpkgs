{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  cpio,
  gzip,
  unar,
  zlib,
  version,
  meta,
  pname,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;
  dontStrip = true;

  src = fetchurl {
    url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/${lib.versions.majorMinor finalAttrs.version}/darwin_${stdenvNoCC.hostPlatform.darwinArch}/snowsql-${finalAttrs.version}-darwin_${stdenvNoCC.hostPlatform.darwinArch}.pkg";
    sha256 =
      if stdenvNoCC.isAarch64
      then "acb2096b87466f0fdbff544d9f64feafc23cbee1bdf963e84b9658511ade9536"
      else "9727c07fc11b1d8adf4a4eb0b5b996d82cd3d9da191a86f4c7b772726f8e5e92";
  };

  nativeBuildInputs = [
    unar
    cpio
    unzip
    gzip
    zlib
  ];

  unpackPhase = ''
    unar $src
  '';

  buildPhase = ''
    cd *snowsql-${finalAttrs.version}-darwin_${stdenvNoCC.hostPlatform.darwinArch}
    cat snowsql-darwin.pkg/Payload | gzip -d | cpio -idmv
    unzip SnowSQL.app/Contents/MacOS/snowsql-${finalAttrs.version}-darwin_${stdenvNoCC.hostPlatform.darwinArch}.zip -d zipped-content
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r zipped-content/* $out/bin/
  '';
})
