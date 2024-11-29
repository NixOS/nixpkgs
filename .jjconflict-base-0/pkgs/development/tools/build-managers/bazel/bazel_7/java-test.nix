{ bazel
, bazelTest
, bazel-examples
, stdenv
, symlinkJoin
, callPackage
, cctools
, extraBazelArgs ? ""
, lib
, openjdk8
, jdk11_headless
, runLocal
, runtimeShell
, writeScript
, writeText
, repoCache ? "unused"
, distDir
}:

let

  localDistDir = callPackage ./bazel-repository-cache.nix {
    lockfile = ./cpp-test-MODULE.bazel.lock;

    # Take all the rules_ deps, bazel_ deps and their transitive dependencies,
    # but none of the platform-specific binaries, as they are large and useless.
    requiredDepNamePredicate = name:
      null == builtins.match ".*(macos|osx|linux|win|apple|android|maven).*" name
      && null != builtins.match "(platforms|com_google_|protobuf|rules_|bazel_).*" name ;
  };

  mergedDistDir = symlinkJoin {
    name = "mergedDistDir";
    paths = [ localDistDir distDir ];
  };

  toolsBazel = writeScript "bazel" ''
    #! ${runtimeShell}

    export CXX='${stdenv.cc}/bin/clang++'
    export LD='${cctools}/bin/ld'
    export LIBTOOL='${cctools}/bin/libtool'
    export CC='${stdenv.cc}/bin/clang'

    # XXX: hack for macosX, this flags disable bazel usage of xcode
    # See: https://github.com/bazelbuild/bazel/issues/4231
    export BAZEL_USE_CPP_ONLY_TOOLCHAIN=1

    exec "$BAZEL_REAL" "$@"
  '';

  workspaceDir = runLocal "our_workspace" {} (''
    cp -r ${bazel-examples}/java-tutorial $out
    find $out -type d -exec chmod 755 {} \;
    cp ${./cpp-test-MODULE.bazel} $out/MODULE.bazel
    cp ${./cpp-test-MODULE.bazel.lock} $out/MODULE.bazel.lock
  ''
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/tools
    cp ${toolsBazel} $out/tools/bazel
  ''));

  testBazel = bazelTest {
    name = "bazel-test-java";
    inherit workspaceDir;
    bazelPkg = bazel;
    buildInputs = [ (if lib.strings.versionOlder bazel.version "5.0.0" then openjdk8 else jdk11_headless) ];
    bazelScript = ''
      ${bazel}/bin/bazel \
        run \
        --announce_rc \
        ${lib.optionalString (lib.strings.versionOlder "5.0.0" bazel.version)
          "--toolchain_resolution_debug='@bazel_tools//tools/jdk:(runtime_)?toolchain_type'"
        } \
        --distdir=${mergedDistDir} \
        --repository_cache=${mergedDistDir} \
        --verbose_failures \
        --curses=no \
        --strict_java_deps=off \
        //:ProjectRunner \
    '' + lib.optionalString (lib.strings.versionOlder bazel.version "5.0.0") ''
        --host_javabase='@local_jdk//:jdk' \
        --java_toolchain='@bazel_tools//tools/jdk:toolchain_hostjdk8' \
        --javabase='@local_jdk//:jdk' \
    '' + extraBazelArgs;
  };

in testBazel

