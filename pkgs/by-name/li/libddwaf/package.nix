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
  version = "2.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "libddwaf";
    tag = finalAttrs.version;
    hash = "sha256-QS6nyd4cyKhZ3cL+5WOgqtBBYecxHqrUAZPBO00fy7M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ rapidjson ];
  strictDeps = true;

  # Use the packaged RapidJSON instead of the vendored copy.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"''${libddwaf_SOURCE_DIR}/src/vendor/rapidjson/include"' '"${lib.getDev rapidjson}/include"'
    substituteInPlace cmake/shared.cmake --replace-fail '-static-libstdc++' '-lstdc++'
  '';

  cmakeFlags = [
    (lib.cmakeBool "LIBDDWAF_TESTING" false)
    (lib.cmakeBool "LIBDDWAF_BUILD_STATIC" false)
    # Upstream uses this value as a hexadecimal ELF build ID.
    (lib.cmakeFeature "GIT_COMMIT" (builtins.hashString "sha1" finalAttrs.src.outputHash))
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
