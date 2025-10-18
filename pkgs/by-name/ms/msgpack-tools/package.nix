{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
}:

let
  libb64 = fetchurl {
    url = "mirror://sourceforge/libb64/libb64-1.2.1.zip";
    hash = "sha256-IBBvC6lc/Zw1oTxxIGZD4/s+RlEt8+Lvsv2/hxFjFLI=";
  };
  rapidjson = fetchurl {
    url = "https://github.com/miloyip/rapidjson/archive/9bd618f545ab647e2c3bcbf2f1d87423d6edf800.tar.gz";
    hash = "sha256-O66yxOidLgLqk5+PAuP67H8eDxnVOK+3BQCQPjrPVxM=";
  };
  mpack = fetchurl {
    url = "https://github.com/ludocode/mpack/archive/df17e83f0fa8571b9cd0d8ccf38144fa90e244d1.tar.gz";
    hash = "sha256-hyiXygbAHnNgF4TIg+DemBvtdBnSgJ7fAhknVuL+T/c=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-tools";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "ludocode";
    repo = "msgpack-tools";
    rev = "v${finalAttrs.version}";
    sha256 = "1ygjk25zlpqjckxgqmahnz999704zy2bd9id6hp5jych1szkjgs5";
  };

  # fix rapidjson dependency version
  # https://github.com/ludocode/msgpack-tools/issues/18
  postPatch = ''
    substituteInPlace CMakeLists.txt \
       --replace-fail 'set(RAPIDJSON_COMMIT "99ba17bd66a85ec64a2f322b68c2b9c3b77a4391")' 'set(RAPIDJSON_COMMIT "9bd618f545ab647e2c3bcbf2f1d87423d6edf800")'
  '';

  postUnpack = ''
    mkdir $sourceRoot/contrib
    cp ${rapidjson} $sourceRoot/contrib/rapidjson-9bd618f545ab647e2c3bcbf2f1d87423d6edf800.tar.gz
    cp ${libb64} $sourceRoot/contrib/libb64-1.2.1.zip
    cp ${mpack} $sourceRoot/contrib/mpack-df17e83f0fa8571b9cd0d8ccf38144fa90e244d1.tar.gz
  '';

  nativeBuildInputs = [ cmake ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/json2msgpack";
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Command-line tools for converting between MessagePack and JSON";
    homepage = "https://github.com/ludocode/msgpack-tools";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
})
