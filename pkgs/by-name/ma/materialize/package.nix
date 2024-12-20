{
  lib,
  stdenv,
  fetchzip,
  rustPlatform,
  fetchFromGitHub,
  protobuf,

  # nativeBuildInputs
  cmake,
  perl,
  pkg-config,
  darwin,

  # buildInputs
  openssl,
  rdkafka,
  apple-sdk_11,
  darwinMinVersionHook,

  versionCheckHook,
  nix-update-script,
}:

let
  fetchNpmPackage =
    {
      name,
      version,
      hash,
      js_prod_file,
      js_dev_file,
      ...
    }@args:
    let
      package = fetchzip {
        url = "https://registry.npmjs.org/${name}/-/${baseNameOf name}-${version}.tgz";
        inherit hash;
      };

      files =
        with args;
        [
          {
            src = js_prod_file;
            dst = "./src/environmentd/src/http/static/js/vendor/${name}.js";
          }
          {
            src = js_prod_file;
            dst = "./src/prof-http/src/http/static/js/vendor/${name}.js";
          }
          {
            src = js_dev_file;
            dst = "./src/environmentd/src/http/static-dev/js/vendor/${name}.js";
          }
          {
            src = js_dev_file;
            dst = "./src/prof-http/src/http/static-dev/js/vendor/${name}.js";
          }
        ]
        ++ lib.optionals (args ? css_file) [
          {
            src = css_file;
            dst = "./src/environmentd/src/http/static/css/vendor/${name}.css";
          }
          {
            src = css_file;
            dst = "./src/prof-http/src/http/static/css/vendor/${name}.css";
          }
        ]
        ++ lib.optionals (args ? extra_file) [
          {
            src = extra_file.src;
            dst = "./src/environmentd/src/http/static/${extra_file.dst}";
          }
          {
            src = extra_file.src;
            dst = "./src/prof-http/src/http/static/${extra_file.dst}";
          }
        ];
    in
    lib.concatStringsSep "\n" (
      lib.forEach files (
        { src, dst }:
        ''
          mkdir -p "${dirOf dst}"
          cp "${package}/${src}" "${dst}"
        ''
      )
    );

  npmPackages = import ./npm_deps.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "materialize";
  version = "0.84.2";
  MZ_DEV_BUILD_SHA = "9f8cf75b461d288335cb6a7a73aaa670bab4a466";

  src = fetchFromGitHub {
    owner = "MaterializeInc";
    repo = "materialize";
    rev = "refs/tags/v${version}";
    hash = "sha256-+cvTCiTbuaPYPIyDxQlMWdJA5/6cbMoiTcSmjj5KPjs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    ${lib.concatStringsSep "\n" (map fetchNpmPackage npmPackages)}
    substituteInPlace ./misc/dist/materialized.service \
      --replace-fail /usr/bin $out/bin \
      --replace-fail _Materialize root
    substituteInPlace ./src/catalog/build.rs \
      --replace-fail '&[ ' '&["."'
  '';

  env = {
    # needed for internal protobuf c wrapper library
    PROTOC = lib.getExe protobuf;
    PROTOC_INCLUDE = "${protobuf}/include";

    # needed to dynamically link rdkafka
    CARGO_FEATURE_DYNAMIC_LINKING = 1;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EHVuwVYPZKaoP3GYtJpYJaKG3CLsy9CWuEmajF4P7Qc=";

  nativeBuildInputs =
    [
      cmake
      perl
      pkg-config
      rustPlatform.bindgenHook
    ]
    # Provides the mig command used by the krb5-src build script
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.bootstrap_cmds;

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs =
    [
      openssl
      rdkafka
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
      apple-sdk_11
      (darwinMinVersionHook "10.13")
    ];

  # the check phase requires linking with rocksdb which can be a problem since
  # the rust rocksdb crate is not updated very often.
  doCheck = false;

  # Skip tests that use the network
  checkFlags = [
    "--exact"
    "--skip test_client"
    "--skip test_client_errors"
    "--skip test_client_all_subjects"
    "--skip test_client_subject_and_references"
    "--skip test_no_block"
    "--skip test_safe_mode"
    "--skip test_tls"
  ];

  cargoBuildFlags = [ "--bin environmentd --bin clusterd" ];

  postInstall = ''
    install --mode=444 -D ./misc/dist/materialized.service $out/etc/systemd/system/materialized.service
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/environmentd";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://materialize.com";
    description = "Streaming SQL materialized view engine for real-time applications";
    license = lib.licenses.bsl11;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ petrosagg ];
    mainProgram = "environmentd";
  };
}
