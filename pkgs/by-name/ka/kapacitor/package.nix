{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  libiconv,
  buildGoModule,
  pkg-config,
}:

let
  libflux_version = "0.171.0";
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = "${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "refs/tags/v${libflux_version}";
      hash = "sha256-v9MUR+PcxAus91FiHYrMN9MbNOTWewh7MT6/t/QWQcM=";
    };
    patches = [
      # This fixes a linting error due to an unneeded call to `.clone()`
      # that gets enforced by a strict `deny(warnings)` build config.
      # This is already fixed with newer versions of `libflux`, but it
      # has been changed in a giant commit with a lot of autmated changes:
      # https://github.com/influxdata/flux/commit/e7f7023848929e16ad5bd3b41d217847bd4fd72b#diff-96572e971d9e19b54290a434debbf7db054b21c9ce19035159542756ffb8ab87
      #
      # Can be removed as soon as kapacitor depends on a newer version of `libflux`, cf:
      # https://github.com/influxdata/kapacitor/blob/v1.7.0/go.mod#L26
      ./fix-linting-error-on-unneeded-clone.patch
      # https://github.com/influxdata/flux/commit/68c831c40b396f0274f6a9f97d77707c39970b02
      ./0001-fix-build.patch

      # https://github.com/influxdata/flux/pull/5273
      # fix compile error with Rust 1.64
      (fetchpatch {
        url = "https://github.com/influxdata/flux/commit/20ca62138a0669f2760dd469ca41fc333e04b8f2.patch";
        stripLen = 2;
        extraPrefix = "";
        hash = "sha256-Fb4CuH9ZvrPha249dmLLI8MqSNQRKqKPxPbw2pjqwfY=";
      })
    ];
    sourceRoot = "${src.name}/libflux";

    cargoHash = "sha256-kbI1uUDE8JyFFtwV5k0EeeNGCZFQLXLobW/MilHX2Sg=";
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;
    pkgcfg = ''
      Name: flux
      Version: ${libflux_version}
      Description: Library for the InfluxData Flux engine
      Cflags: -I/out/include
      Libs: -L/out/lib -lflux -lpthread
    '';
    passAsFile = [ "pkgcfg" ];
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
      substitute $pkgcfgPath $out/pkgconfig/flux.pc \
        --replace-fail /out $out
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';
  };
in
buildGoModule rec {
  pname = "kapacitor";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-vxaLfJq0NFAJst0/AEhNJUl9dAaZY3blZAFthseMSX0=";
  };

  vendorHash = "sha256-myToEgta8R5R4v2/nZqtQQvNdy1kWgwklbQeFxzIdgs=";

  nativeBuildInputs = [ pkg-config ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";

  # Check that libflux is at the right version
  preBuild = ''
    flux_ver=$(grep github.com/influxdata/flux go.mod | awk '{print $2}')
    if [ "$flux_ver" != "v${libflux_version}" ]; then
      echo "go.mod wants libflux $flux_ver, but nix derivation provides ${libflux_version}"
      exit 1
    fi
  '';

  # Remove failing server tests
  preCheck = ''
    rm server/server_test.go
    rm pipeline/tick/*test.go
  '';

  checkFlags =
    let
      skippedTests = [
        "TestBatch_KapacitorLoopback"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  # Tests start http servers which need to bind to local addresses,
  # but that fails in the Darwin sandbox by default unless this option is turned on
  # Error is: panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  # See also https://github.com/NixOS/nix/pull/1646
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    downloadPage = "https://github.com/influxdata/kapacitor/releases";
    license = lib.licenses.mit;
    changelog = "https://github.com/influxdata/kapacitor/blob/master/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      offline
      totoroot
    ];
  };
}
