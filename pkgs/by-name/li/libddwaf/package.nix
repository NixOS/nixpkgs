{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rapidjson,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libddwaf";
  version = "2.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "libddwaf";
    tag = finalAttrs.version;
    hash = "sha256-qFQN949O1X+Di4eVniPc3pIGPTt0lXTklNON2ty5XCo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ rapidjson ];
  strictDeps = true;

  # Upstream downloads its dependencies using ExternalProject_Add.
  postPatch = ''
    cat > third_party/CMakeLists.txt <<EOF
    add_library(lib_rapidjson INTERFACE IMPORTED GLOBAL)
    target_include_directories(lib_rapidjson INTERFACE ${lib.getDev rapidjson}/include)
    target_compile_definitions(lib_rapidjson INTERFACE RAPIDJSON_HAS_STDSTRING=1)
    EOF
    substituteInPlace cmake/shared.cmake --replace-fail '-static-libstdc++' '-lstdc++'
  '';

  cmakeFlags = [
    (lib.cmakeBool "LIBDDWAF_TESTING" false)
    (lib.cmakeBool "LIBDDWAF_BUILD_STATIC" false)
    (lib.cmakeFeature "GIT_COMMIT" "affa1897d1613e36258ce0e68d7eb0fbd5ffa4bf")
  ];

  passthru.tests.link =
    runCommand "libddwaf-link-test"
      {
        nativeBuildInputs = [ stdenv.cc ];
        buildInputs = [ finalAttrs.finalPackage ];
      }
      ''
        cat > test.c <<'EOF'
        #include <ddwaf.h>
        #include <stdio.h>
        #include <string.h>

        int main(void) {
          const char *version = ddwaf_get_version();
          puts(version);
          return strcmp(version, "${finalAttrs.version}") != 0;
        }
        EOF
        $CC test.c -lddwaf -o test
        ./test
        touch "$out"
      '';

  meta = {
    description = "Datadog web application firewall library";
    homepage = "https://github.com/DataDog/libddwaf";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.jbiel ];
  };
})
