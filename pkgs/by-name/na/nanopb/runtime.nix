{ cmake
, lib
, stdenv
, protobuf
, python3
, src
, version
, enable_malloc
, no_packed_structs
, max_required_fields
, field_32bit
, no_errmsg
, buffer_only
, system_header
, without_64bit
, encode_arrays_unpacked
, convert_double_float
, validate_utf8
, little_endian_8bit
, c99_static_assert
, no_static_assert
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
            { cond = enable_malloc; flag = "ENABLE_MALLOC=1"; }
            { cond = no_packed_structs; flag = "NO_PACKED_STRUCTS=1"; }
            { cond = max_required_fields != null; flag = "MAX_REQUIRED_FIELDS=${max_required_fields}"; }
            { cond = field_32bit; flag = "FIELD_32BIT=1"; }
            { cond = no_errmsg; flag = "NO_ERRMSG=1"; }
            { cond = buffer_only; flag = "BUFFER_ONLY=1"; }
            { cond = system_header != null; flag = "SYSTEM_HEADER=${system_header}"; }
            { cond = without_64bit; flag = "WITHOUT_64BIT=1"; }
            { cond = encode_arrays_unpacked; flag = "ENCODE_ARRAYS_UNPACKED=1"; }
            { cond = convert_double_float; flag = "CONVERT_DOUBLE_FLOAT=1"; }
            { cond = validate_utf8; flag = "VALIDATE_UTF8=1"; }
            { cond = little_endian_8bit; flag = "LITTLE_ENDIAN_8BIT=1"; }
            { cond = c99_static_assert; flag = "C99_STATIC_ASSERT=1"; }
            { cond = no_static_assert; flag = "NO_STATIC_ASSERT=1"; }
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
