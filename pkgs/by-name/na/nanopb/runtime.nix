{ cmake
, lib
, stdenv
, protobuf
, python3
, src
, version
, enableMalloc
, noPackedStructs
, maxRequiredFields
, field32bit
, noErrmsg
, bufferOnly
, systemHeader
, without64bit
, encodeArraysUnpacked
, convertDoubleFloat
, validateUtf8
, littleEndian8bit
, c99StaticAssert
, noStaticAssert
}:

stdenv.mkDerivation
  ({
    pname = "nanopb-runtime";
    inherit src version;

    nativeBuildInputs = [ cmake protobuf python3 ];

    patchPhase =
      let
        compile_definitions = target: ''
          target_compile_definitions(${target}
            PUBLIC
            ${lib.concatStringsSep "\n\t" (map (x: "PB_${x.flag}")
          (builtins.filter (x: x.cond) [
            { cond = enableMalloc; flag = "ENABLE_MALLOC=1"; }
            { cond = noPackedStructs; flag = "NO_PACKED_STRUCTS=1"; }
            { cond = maxRequiredFields != null; flag = "MAX_REQUIRED_FIELDS=${maxRequiredFields}"; }
            { cond = field32bit; flag = "FIELD_32BIT=1"; }
            { cond = noErrmsg; flag = "NO_ERRMSG=1"; }
            { cond = bufferOnly; flag = "BUFFER_ONLY=1"; }
            { cond = systemHeader != null; flag = "SYSTEM_HEADER=${systemHeader}"; }
            { cond = without64bit; flag = "WITHOUT_64BIT=1"; }
            { cond = encodeArraysUnpacked; flag = "ENCODE_ARRAYS_UNPACKED=1"; }
            { cond = convertDoubleFloat; flag = "CONVERT_DOUBLE_FLOAT=1"; }
            { cond = validateUtf8; flag = "VALIDATE_UTF8=1"; }
            { cond = littleEndian8bit; flag = "LITTLE_ENDIAN_8BIT=1"; }
            { cond = c99StaticAssert; flag = "C99_STATIC_ASSERT=1"; }
            { cond = noStaticAssert; flag = "NO_STATIC_ASSERT=1"; }
          ]))}
          )
        '';
      in
      ''
        cat << EOF >> CMakeLists.txt
          ${compile_definitions "protobuf-nanopb"}
          ${compile_definitions "protobuf-nanopb-static"}
        EOF
      '';

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_STATIC_LIBS=ON"
      "-Dnanopb_BUILD_GENERATOR=OFF"
      "-Dnanopb_BUILD_RUNTIME=ON"
    ];
  })
