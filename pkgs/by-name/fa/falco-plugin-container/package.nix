{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  cmake,
  btrfs-progs,
  nix-update-script,
}:

let
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "plugins";
    tag = "plugins/container/v${version}";
    hash = "sha256-MmzIK2ttTl5CIwyr9upahZTsf4pByIDl/YqQgRsOF/k=";
  };

  # Compare with https://github.com/falcosecurity/plugins/tree/plugins/container/v0.7.5/plugins/container/cmake/modules
  pluginSdkCpp = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "plugin-sdk-cpp";
    tag = "0.3.0";
    hash = "sha256-Ouu0iTDuTNECvxUJhPt4UR+l5qDiTI2V34+6NuPFK7k=";
  };

  reflex = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    tag = "v5.3.0";
    hash = "sha256-OKBcRAAz0d0xS5UunnlE8OqYQrzyKMym/yAVxD5+hcU=";
  };

  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    tag = "11.1.4";
    hash = "sha256-sUbxlYi/Aupaox3JjWFqXIjcaQa0LFjclQAOleT+FRA=";
  };

  # Talks to the container runtimes' sockets; linked into the plugin as a
  # static archive, so this builds libworker.a and its header, not a program.
  worker = buildGoModule {
    pname = "falco-plugin-container-worker";
    inherit version src;

    modRoot = "plugins/container/go-worker";
    vendorHash = "sha256-ahPZohkFh5yTg3hEXHgznjgVoJyv4CTJhqx7pNoBeOg=";

    buildInputs = [ btrfs-progs ];

    buildPhase = ''
      runHook preBuild
      go build -tags containers_image_openpgp -ldflags="-s -w" -buildmode=c-archive -o libworker.a .
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 libworker.a -t $out/lib
      install -Dm644 libworker.h -t $out/include
      runHook postInstall
    '';

    doCheck = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "falco-plugin-container";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/plugins/container";

  postPatch = ''
    # The build fetches these and builds the worker itself; use the ones above.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'include(go-worker)
        add_dependencies(container go-worker)' 'set(WORKER_LIB ${worker}/lib/libworker.a)
        set(WORKER_INCLUDE ${worker}/include)
        set(WORKER_DEP resolv)' \
      --replace-fail ' -static-libgcc -static-libstdc++' ""
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PLUGIN-SDK-CPP" "${pluginSdkCpp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REFLEX" "${reflex}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt}")
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 libcontainer.so -t $out/lib
    runHook postInstall
  '';

  passthru = {
    inherit worker;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "plugins/container/v(.*)"
      ];
    };
  };

  meta = {
    description = "Falco plugin that enriches events with container metadata";
    homepage = "https://github.com/falcosecurity/plugins/tree/main/plugins/container";
    changelog = "https://github.com/falcosecurity/plugins/blob/plugins/container/v${finalAttrs.version}/plugins/container/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
