{
  stdenv,
  fetchFromGitHub,
  lib,

  # nativeBuildInputs
  cmake,

  # buildInputs
  tomlplusplus,
  yaml-cpp,
  pugixml,
  msgpack-c,
  avro-cpp,
  capnproto,
  libcbor,
  flatbuffers,
  arrow-cpp,
  jsoncons,

  # passthru
  nix-update-script,

  # flags
  enableTOML ? false,
  enableYAML ? false,
  enableXML ? false,
  enableMsgpack ? false,
  enableAvro ? false,
  enableBSON ? false,
  enableCapnproto ? false,
  enableCBOR ? false,
  enableFlexbuffers ? false,
  enableCSV ? false,
  enableUBJSON ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "reflect-cpp";
  version = "0.25.0";

  src = fetchFromGitHub {
    repo = "reflect-cpp";
    owner = "getml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ohj8Oue2Q/02r9hJmGw2bl6qW2xUsbjFJTquHG8JvcI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    (lib.optionals enableTOML tomlplusplus)
    ++ (lib.optionals enableYAML yaml-cpp)
    ++ (lib.optionals enableXML pugixml)
    ++ (lib.optionals enableMsgpack msgpack-c)
    ++ (lib.optionals enableAvro avro-cpp)
    ++ (lib.optionals enableCapnproto capnproto)
    ++ (lib.optionals enableCBOR libcbor)
    ++ (lib.optionals enableFlexbuffers flatbuffers)
    ++ (lib.optionals enableCSV arrow-cpp)
    ++ (lib.optionals enableUBJSON jsoncons);

  cmakeFlags = [
    # Force this to false, because otherwise reflect-cpp tries
    # to use VCPkg to pull in its build dependencies
    (lib.cmakeBool "REFLECTCPP_USE_VCPKG" false)
    (lib.cmakeBool "REFLECTCPP_TOML" enableTOML)
    (lib.cmakeBool "REFLECTCPP_YAML" enableYAML)
    (lib.cmakeBool "REFLECT_XML" enableXML)
    (lib.cmakeBool "REFLECTCPP_MSGPACK" enableMsgpack)
    (lib.cmakeBool "REFLECTCPP_AVRO" enableAvro)
    (lib.cmakeBool "REFLECTCPP_BSON" enableBSON)
    (lib.cmakeBool "REFLECTCPP_CAPNPROTO" enableCapnproto)
    (lib.cmakeBool "REFLECTCPP_CBOR" enableCBOR)
    (lib.cmakeBool "REFLECTCPP_FLEXBUFFERS" enableFlexbuffers)
    (lib.cmakeBool "REFLECTCPP_CSV" enableCSV)
    (lib.cmakeBool "REFLECTCPP_UBJSON" enableUBJSON)
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C++20 Library for fast serialization and deserialization.";
    homepage = "http://rfl.getml.com/";
    changelog = "https://github.com/getml/reflect-cpp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.evanwporter ];
    platforms = lib.platforms.all;
  };
})
