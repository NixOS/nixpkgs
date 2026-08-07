{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  rapidjson,
  replaceVars,
  libb64,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-tools";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "ludocode";
    repo = "msgpack-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RT85vw6QeVkuNC2mtoT/BJyU0rdQVfz6ZBJf+ouY8vk=";
  };

  mpack = fetchurl {
    url = "https://github.com/ludocode/mpack/archive/df17e83f0fa8571b9cd0d8ccf38144fa90e244d1.tar.gz";
    hash = "sha256-hyiXygbAHnNgF4TIg+DemBvtdBnSgJ7fAhknVuL+T/c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rapidjson
    libb64
  ];

  patches = [
    ./cmake-v4.patch
    (replaceVars ./use-nix-deps.patch {
      rapidjson = "${rapidjson}";
      libb64 = "${libb64}";
    })
  ];

  postUnpack = ''
    mkdir $sourceRoot/contrib
    cp ${finalAttrs.mpack} $sourceRoot/contrib/mpack-df17e83f0fa8571b9cd0d8ccf38144fa90e244d1.tar.gz
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/json2msgpack";
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Command-line tools for converting between MessagePack and JSON";
    homepage = "https://github.com/ludocode/msgpack-tools";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ deejayem ];
  };
})
