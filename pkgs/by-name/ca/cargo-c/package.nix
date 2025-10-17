{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  openssl,
  stdenv,
  libiconv,
  rav1e,
}:

let
  # this version may need to be updated along with package version
  cargoVersion = "0.90.0";
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.10.15";

  src = fetchCrate {
    inherit pname;
    version = "${version}+cargo-${cargoVersion}";
    hash = "sha256-szqDSHGihE+Oj8L3EBlC5XH4kSBYOptd0Xtk3MhXooQ=";
  };

  cargoHash = "sha256-36ygs/EhCktG1jmBnP9c7EgnfcWnGrqqcW3qAw+Yfy4=";

  nativeBuildInputs = [
    pkg-config
    (lib.getDev curl)
  ];
  buildInputs = [
    openssl
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Ensure that we are avoiding build of the curl vendored in curl-sys
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/cargo-cbuild" | grep libcurl.so

    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      inherit rav1e;
    };
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    description = "Cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
    longDescription = ''
      Cargo C-ABI helpers. A cargo applet that produces and installs a correct
      pkg-config file, a static library and a dynamic library, and a C header
      to be used by any C (and C-compatible) software.
    '';
    homepage = "https://github.com/lu-zero/cargo-c";
    changelog = "https://github.com/lu-zero/cargo-c/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cpu
      matthiasbeyer
    ];
  };
}
