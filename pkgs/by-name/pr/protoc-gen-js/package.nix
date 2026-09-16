{
  stdenv,
  gcc14Stdenv,
  lib,
  buildBazelPackage,
  bazel_7,
  fetchFromGitHub,
  cctools,
}:

let
  # fails to build with gcc15, see https://github.com/NixOS/nixpkgs/issues/475586
  buildBazelPackage' =
    if stdenv.cc.isGNU then
      buildBazelPackage.override {
        stdenv = gcc14Stdenv;
      }
    else
      buildBazelPackage;

  # Since 4.0.0 the project resolves its dependencies with bzlmod instead of a
  # WORKSPACE file. Bazel needs the registry to compute the main repo mapping in
  # the (sandboxed, network-less) build phase as well, so pin a checkout of the
  # Bazel Central Registry instead of letting Bazel reach out to
  # https://bcr.bazel.build.
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0f256a72067e42d62bb568cc2619f98deed139e2";
    hash = "sha256-OcMLg0KiAQOJZLH8r+QkeQ9bxcEc4L0dCgyUv5PkLQk=";
  };
in
buildBazelPackage' rec {
  pname = "protoc-gen-js";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    rev = "v${version}";
    hash = "sha256-vFTR7dwquZht4st90bFQ9CJMYBPbL+DWO0uQ3xsXIBU=";
  };

  bazel = bazel_7;
  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];
  bazelTargets = [ "generator:protoc-gen-js" ];
  bazelBuildFlags = lib.optionals stdenv.cc.isClang [
    "--cxxopt=-x"
    "--cxxopt=c++"
    "--host_cxxopt=-x"
    "--host_cxxopt=c++"
  ];
  removeRulesCC = false;

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LIBTOOL = "${cctools}/bin/libtool";
  };

  fetchAttrs = {
    preInstall = ''
      # Bazel generates these repositories by inspecting the build host, so they
      # must not be captured in the fixed-output deps tarball: they leak store
      # paths into it (which trips allowedRequisites) and they pin the host CPU,
      # which would make the single hash below wrong on every platform but the
      # one it was generated on. Bazel regenerates all of them offline during the
      # build phase.
      #
      # buildBazelPackage already drops the unprefixed `local_*` repositories,
      # but since 4.0.0 the project builds with bzlmod, which namespaces them by
      # the module extension that creates them (`~` separator on Bazel 7, `+` on
      # Bazel 8+) so the plain globs no longer match. The ones that matter here:
      #
      #   *~local_config_cc_toolchains    registers @local_config_cc//:cc-compiler-k8
      #   *~local_config_shell            embeds the absolute path of the build shell
      #   *~host_platform                 (already handled before the bzlmod switch)
      rm -rf "$bazelOut"/external/*[~+]{host_platform,local_config_*}
    '';

    hash = "sha256-bc+VwWhHzXIblFGYf8gfRTZvAiBY4L9L9texuJlxRYI=";
  };

  buildAttrs.installPhase = ''
    mkdir -p $out/bin
    install -Dm755 bazel-bin/generator/protoc-gen-js $out/bin/
  '';

  meta = {
    description = "Protobuf plugin for generating JavaScript code";
    mainProgram = "protoc-gen-js";
    homepage = "https://github.com/protocolbuffers/protobuf-javascript";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.byteflavour ];
  };
}
