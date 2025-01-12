{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  darwin,
  openssl,
  pkg-config,
}:

let
  pname = "edge-runtime";
  version = "1.60.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w0iSKHT6aIixKh1bHg1lOQNEw/emKK7R2iLzWjb2Pnk=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "deno_core-0.293.0" = "sha256-5WBORHokzWPdro9rmBijcsx/j81YFaEfMIK276bfI1o=";
      "eszip-0.72.2" = "sha256-lzJeapA5NTWBnBaQY8i82OeYN2DIukJZKoRAXFG4qVA=";
      "ort-2.0.0-rc.2" = "sha256-jOKeulnW/m+q1xf77jaNzLT+In/AFcSDDbz7xF23x5g=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreFoundation
        SystemConfiguration
      ]
    );

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = callPackage ./librusty_v8.nix { };

  # For version tag
  GIT_V_TAG = version;

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/edge-runtime --help
    runHook postInstallCheck
  '';

  doCheck = false;

  meta = with lib; {
    description = "Server based on Deno runtime, capable of running JavaScript, TypeScript, and WASM services";
    mainProgram = "edge-runtime";
    homepage = "https://github.com/supabase/edge-runtime";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
