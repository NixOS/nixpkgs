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
  cargoVersion = "0.89.0";
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.10.14";

  src = fetchCrate {
    inherit pname;
    version = "${version}+cargo-${cargoVersion}";
    hash = "sha256-t6cbufPdpyaFzwEFWt19Nid2S5FXCJCS+SHJ0aJICX0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nW+akmbpIGZnhJLBdwDAGI4m5eSwdT2Z/iY2RV4zMQY=";

  nativeBuildInputs = [
    pkg-config
    (lib.getDev curl)
  ];
  buildInputs =
    [
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
