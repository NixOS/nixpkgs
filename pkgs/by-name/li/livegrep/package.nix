{
  lib,
  stdenv,
  fetchFromGitHub,
  buildBazelPackage,
  bazel_7,
  nix-update-script,
  applyPatches,
  nodejs,
  cctools,
}:
let
  cc_tools = [
    "codesearch"
    "analyze-re"
    "dump-file"
    "inspect-index"
  ];

  go_tools = [
    "livegrep"
    "lg"
    "livegrep-fetch-reindex"
    "livegrep-github-reindex"
    "livegrep-reload"
  ];

  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0f256a72067e42d62bb568cc2619f98deed139e2";
    hash = "sha256-OcMLg0KiAQOJZLH8r+QkeQ9bxcEc4L0dCgyUv5PkLQk=";
  };

  rules_js = applyPatches {
    src = fetchFromGitHub {
      owner = "aspect-build";
      repo = "rules_js";
      rev = "v2.4.0";
      hash = "sha256-Z0Oq5FQ26KS+tLwawXs2Jgox0Cau4E76IwzNKyTK0Tk=";
    };

    patches = [
      ./rule-js-Fix-toolchain-with-npm_path.patch
    ];

    postPatch = ''
      patchShebangs --build \
        npm/private/lifecycle/bundle.sh \
        npm/private/lifecycle/min/node-gyp-bin/node-gyp \
        npm/private/noop.sh \
        npm/private/versions_mirror.sh \
        js/private/node_wrapper.sh \
        js/private/npm_wrapper.sh

      substituteInPlace \
        npm/private/utils.bzl \
        npm/private/lifecycle/lifecycle-hooks.js \
        npm/private/lifecycle/min/index.min.js \
        js/private/js_binary.sh.tpl \
        --replace-fail '#!/usr/bin/env bash' "#!$(type -p bash)"
    '';
  };

  bazelDepsHashByBuildAndHost = {
    x86_64-linux.x86_64-linux = "sha256-PastkoOioWqlmGFHZiZ2S1ahWZu1UBhqHIfD2M/ff6A=";
    aarch64-linux.aarch64-linux = "sha256-mNWnpmk/dNQYKnP3YbfK5ott0+41I+49aH6RhWEMOGM=";
  };
  bazelDepsHashByHost = bazelDepsHashByBuildAndHost.${stdenv.buildPlatform.system} or { };
  bazelDepsHash = bazelDepsHashByHost.${stdenv.hostPlatform.system} or "";
in
buildBazelPackage {
  pname = "livegrep";
  version = "2026-02-10";

  src = fetchFromGitHub {
    owner = "livegrep";
    repo = "livegrep";
    rev = "923d5ad71dfe60900e6c2017b2fa4a5ff902ad71";
    hash = "sha256-SYbJJuUX13otaGRsYLTp6XWU3BBNmtNIpUxyu11U+b0=";
  };

  patches = [
    ./livegrep-Use-patched-rules_js-and-nodejs-from-nixpkgs.patch
  ];

  postPatch = ''
    substituteInPlace nixpkgs-toolchains/BUILD.bazel --subst-var-by nodejs "${nodejs}"
    substituteInPlace MODULE.bazel --subst-var-by rules_js "${rules_js}"
  '';

  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LIBTOOL = "${cctools}/bin/libtool";
  };

  fetchAttrs = {
    preInstall = ''
      # Avoid bash and $out store paths leaking into the fixed-output derivation
      rm $bazelOut/external/aspect_rules_js~~npm~npm/_exists.sh
      rm -r $bazelOut/external/rules_shell~~sh_configure~local_config_shell

      # Remove some non-reproducible and unused files
      rm -r $bazelOut/external/gazelle~~non_module_deps~bazel_gazelle_go_repository_cache
      rm -r $bazelOut/external/gazelle~~non_module_deps~bazel_gazelle_go_repository_tools
    '';

    hash = bazelDepsHash;
  };

  bazel = bazel_7;

  bazelBuildFlags = [ "-c opt" ];
  bazelTargets =
    (builtins.map (tool: "//src/tools:${tool}") cc_tools)
    ++ (builtins.map (tool: "//cmd/${tool}") go_tools);

  buildAttrs = {
    installPhase = ''
      pushd "bazel-bin/src/tools"
      install -Dt "$out/bin" ${builtins.toString cc_tools}
      popd

      for go_tool in ${builtins.toString go_tools}; do
        install -D -t "$out/bin" "bazel-bin/cmd/$go_tool/''${go_tool}_/$go_tool"
      done

      mkdir -p "$out/bin/livegrep.runfiles/com_github_livegrep_livegrep"
      cp -Lr "bazel-bin/cmd/livegrep/livegrep_/livegrep.runfiles/_main/web" "$out/bin/livegrep.runfiles/com_github_livegrep_livegrep"
    '';
  };

  passthru = {
    inherit rules_js;
    updateScript = nix-update-script { };
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Livegrep is a tool, partially inspired by Google Code Search, for interactive regex search of ~gigabyte-scale source repositories.";
    homepage = "http://livegrep.com/";
    downloadPage = "https://github.com/livegrep/livegrep";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nicolas-guichard ];
    mainProgram = "livegrep";
    badPlatforms = [
      # Error in fail: Unable to find a CC toolchain using toolchain resolution
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
