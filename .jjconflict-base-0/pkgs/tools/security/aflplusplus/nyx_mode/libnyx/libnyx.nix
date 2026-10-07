{
  lib,
  stdenv,
  rustPlatform,
  aflplusplus,
  python3,
}:

rustPlatform.buildRustPackage {
  version = builtins.readFile (aflplusplus.src + "/nyx_mode/LIBNYX_VERSION");
  pname = "libnyx";

  src = aflplusplus.src;
  postUnpack = ''
    sourceRoot="$sourceRoot/nyx_mode/libnyx/libnyx"
    cp ${./Cargo.lock} "$sourceRoot/Cargo.lock"
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp "target/${stdenv.hostPlatform.rust.rustcTarget}/release/liblibnyx.so" $out/lib/libnyx.so
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/nyx-fuzz/libnyx";
    description = "Rust library to build hypervisor-based snapshot fuzzers";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ekzyis ];
  };
}
