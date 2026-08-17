{
  lib,
  pkgs,
  nixosTests,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  pkg-config,
  cmake,
  openssl,
  libffi,
  grpc,
  nix-update-script,
  python3Packages,
}:
let
  #script to generate the fernet key
  fernetKey =
    {
      src,
      version,
    }:
    python3Packages.buildPythonApplication {
      pname = "fernet_key";
      inherit version src;

      __structuredAttrs = true;

      format = "other";

      # this would run the upstream docker makefile
      dontBuild = true;

      dependencies = [ python3Packages.cryptography ];

      installPhase = ''
        mkdir -p $out/bin
        echo "#!/usr/bin/env python3" |  \
        cat - $src/scripts/fernet_key.py > $out/bin/fernet_key
        chmod +x $out/bin/fernet_key
      '';

      postFixup = ''
        wrapPythonPrograms
      '';
    };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autopush";
  version = "1.82.1";

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "fernet"
  ];

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "autopush-rs";
    tag = finalAttrs.version;
    hash = "sha256-wOnuYh18q2XDAcCUBGsidAMvOi10s4njVKDLhtNJEoU=";
  };

  cargoHash = "sha256-FiMEDc2wxQPkM50cNKzP8yo90HGMakn6JUl/xheaciQ=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    cmake
  ];

  buildInputs = [
    openssl
    libffi
    grpc
  ];

  # by default only google bigtable is supported as a db
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "postgres"
    "redis"
    "reliable_report"
  ];

  env = {
    #needed for bingen to find libc
    BINDGEN_EXTRA_CLANG_ARGS = "-I${stdenv.cc.libc.dev}/include";
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  };

  #check build fails
  doCheck = false;

  postInstall = ''
    mkdir -p $fernet/bin
    ln -s ${fernetKey { inherit (finalAttrs) src version; }}/bin/fernet_key $fernet/bin/fernet_key
  '';

  passthru = {
    tests = nixosTests.autopush-rs;
    services.autoconnect = {
      imports = [
        (lib.modules.importApply ./service-autoconnect.nix { inherit pkgs; })
      ];
      package = finalAttrs.finalPackage.out;
    };
    services.autoendpoint = {
      imports = [
        (lib.modules.importApply ./service-autoendpoint.nix { inherit pkgs; })
      ];
      package = finalAttrs.finalPackage.out;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mozilla Push server and Push Endpoint";
    homepage = "https://mozilla-services.github.io/autopush-rs/index.html";
    changelog = "https://github.com/mozilla-services/autopush-rs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.zimward
    ];
    # install the fernet_key script in devshells as users will only use it once most likely
    outputsToInstall = [
      "out"
      "fernet"
    ];
  };
})
