{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rapidjson,
  unzip,
  configure_host ? null,
  configure_debug ? false,
}:
let
  mpack = fetchFromGitHub {
    owner = "ludocode";
    repo = "mpack";
    rev = "df17e83f0fa8571b9cd0d8ccf38144fa90e244d1";
    hash = "sha256-qlWVOAqlYcOkFdsAOFM9LIximjjxaemHM9lT4xx7htQ=";
  };
  libb64-version = "1.2.1";
  libb64 = fetchurl {
    url = "mirror://sourceforge/libb64/libb64-${libb64-version}.zip";
    hash = "sha256-IBBvC6lc/Zw1oTxxIGZD4/s+RlEt8+Lvsv2/hxFjFLI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-tools";
  version = "1.0-unstable-2021-09-12";

  src = fetchFromGitHub {
    owner = "ludocode";
    repo = "msgpack-tools";
    rev = "9b8dbcf74ac1ca3c8e02da57109f09758ee2eb7c";
    hash = "sha256-VOGK1HtKQjbbGF1f8WI3coiYkH2usXjD+MoQUC5QrWY=";
  };

  postUnpack = ''
    mkdir -p $sourceRoot/contrib/mpack $sourceRoot/contrib/rapidjson $sourceRoot/contrib/libb64
    cp ${libb64} $sourceRoot/contrib/libb64-${libb64-version}.zip
    ${lib.getExe unzip} $sourceRoot/contrib/libb64-${libb64-version}.zip -d $sourceRoot/contrib/libb64-tmp
    mv $sourceRoot/contrib/libb64-tmp/libb64-${libb64-version}/* $sourceRoot/contrib/libb64
    rm -rf $sourceRoot/contrib/libb64-tmp $sourceRoot/contrib/libb64-${libb64-version}.zip
    cp -r ${mpack}/** $sourceRoot/contrib/mpack
    cp -r ${rapidjson}/** $sourceRoot/contrib/rapidjson
  '';

  dontConfigure = true;

  preBuild = ''
    cat > config.mk <<EOF
    ${lib.optionalString (
      configure_host != null
    ) "HOST = ${configure_host}\nTOOL_PREFIX = ${configure_host}-\n"}
    PREFIX = $out
    DEBUG = ${toString configure_debug}
    LIBB64_VERSION = ${libb64-version}
    EOF
  '';

  meta = {
    description = "Command-line tools for converting between MessagePack and JSON";
    homepage = "https://github.com/ludocode/msgpack-tools";
    changelog = "https://github.com/ludocode/msgpack-tools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
