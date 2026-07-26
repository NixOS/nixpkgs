{
  lib,
  stdenv,
  buildGo125Module,
  fetchFromCodeberg,
  fetchYarnDeps,
  nodejs,
  yarn,
  yarnConfigHook,
  makeBinaryWrapper,
  ffmpeg,
  nixosTests,
  nix-update-script,
  # Wazero (the WASM runtime GoToSocial uses to bundle ffmpeg/ffprobe/sqlite3)
  # only has a fast "compiler" backend for amd64 and arm64. On every other
  # architecture (riscv64, 32-bit ARM, ppc64le, ...) it falls back to a WASM
  # interpreter that is far too slow for real-world media processing.
  # Upstream exposes the explicitly unsupported/experimental "nowasm" build
  # tag for this situation: it drops the embedded WASM ffmpeg/ffprobe/sqlite3
  # and instead shells out to ffmpeg/ffprobe binaries found on $PATH.
  # See: https://docs.gotosocial.org/en/latest/advanced/builds/nowasm/
  withWasm ? stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64,
}:
buildGo125Module (finalAttrs: {
  pname = "gotosocial";
  version = "0.22.1";

  src = fetchFromCodeberg {
    owner = "superseriousbusiness";
    repo = "gotosocial";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fRMQISOYf0rGcnNBpdlDeYWO0vvVwW0UPXdeT1y0+Ec=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  tags = [
    "kvformat"
  ]
  ++ lib.optionals (!withWasm) [ "nowasm" ];

  nativeBuildInputs = [
    nodejs
    yarn
    yarnConfigHook
  ]
  ++ lib.optionals (!withWasm) [ makeBinaryWrapper ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/source/yarn.lock";
    hash = "sha256-rfZxslIEoOTufENIvk8Eq5wzdD3rUpUP3wrMjmLH44k=";
  };

  # manually calling yarnConfigHook in sub-directory
  dontYarnInstallDeps = true;

  postConfigure = ''
    pushd ./web/source
    runHook yarnConfigHook
    popd
  '';

  # preparing assets
  # https://codeberg.org/superseriousbusiness/gotosocial/src/branch/main/.goreleaser.yml#L12
  preBuild = ''
    go run ./vendor/github.com/go-swagger/go-swagger/cmd/swagger generate spec --scan-models --exclude-deps -o web/assets/swagger.yaml
    substituteInPlace web/assets/swagger.yaml --replace-fail "REPLACE_ME" "${finalAttrs.version}"
    yarn --offline --cwd ./web/source ts-patch install
    yarn --offline --cwd ./web/source build
    ./scripts/bundle_licenses.sh
  '';

  postInstall = ''
    # remove a Go codegen helper binary
    rm $out/bin/gen

    mkdir -p $out/share/gotosocial/web
    mv web/{assets,template} $out/share/gotosocial/web
  ''
  + lib.optionalString (!withWasm) ''
    # nowasm builds need ffmpeg/ffprobe available on $PATH at runtime,
    # since the embedded WASM copies have been compiled out.
    wrapProgram $out/bin/gotosocial \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  # tests are working only on x86_64-linux
  # doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64;
  # checks are currently very unstable in our setup, so we should test manually for now
  doCheck = false;

  checkFlags =
    let
      # flaky / broken tests
      skippedTests = [
        # See: https://github.com/superseriousbusiness/gotosocial/issues/2651
        "TestPage/minID,_maxID_and_limit_set"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.gotosocial = nixosTests.gotosocial;
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gotosocial.org";
    changelog = "https://codeberg.org/superseriousbusiness/gotosocial/releases/tag/v${finalAttrs.version}";
    description = "Fast, fun, ActivityPub server, powered by Go";
    longDescription = ''
      ActivityPub social network server, written in Golang.
      You can keep in touch with your friends, post, read, and
      share images and articles. All without being tracked or
      advertised to! A light-weight alternative to Mastodon
      and Pleroma, with support for clients!
    '';
    maintainers = with lib.maintainers; [
      blakesmith
      cherrykitten
    ];
    license = lib.licenses.agpl3Only;
  };
})
