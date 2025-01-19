{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  fetchFromGitHub,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  jq,
  zsh,
  openssl,
}:

let
  tauri = cargo-tauri;

in
rustPlatform.buildRustPackage rec {
  pname = "neohtop";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "abdenasser";
    repo = "neohtop";
    rev = "refs/tags/v${version}";
    hash = "sha256-23r/oBR4zWmeSVa5QaJ2wJOwzwmqYVhMKOpaEABP7Qs=";
  };

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    tauri.hook
    npmHooks.npmConfigHook
    nodejs
    jq
  ];

  cargoRoot = "src-tauri";
  cargoLock.lockFile = ./Cargo.lock;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-6FWowWVVeU7U5aM4WGVWv0WmauLv/F4mtSdjNeeF6eQ=";
  };

  # unfortunately, es explained in https://github.com/NixOS/nixpkgs/pull/354565#issuecomment-2479346612
  # some optional, but needed dependencies are not included in the upstream Cargo.lock file
  postPatch = ''
    rm ${cargoRoot}/Cargo.lock
    cp ${./Cargo.lock} ${cargoRoot}/Cargo.lock
    chmod +w ${cargoRoot}/Cargo.lock
  '';
  # remove macOS signing
  postConfigure = ''
    jq 'del(.bundle.macOS.signingIdentity, .bundle.macOS.hardenedRuntime)' src-tauri/tauri.conf.json > src-tauri/tauri.conf.json
    mv tmp.json src-tauri/tauri.conf.json
  '';
  
  installPhase =
    let
      path = "${cargoRoot}/target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/bundle";
    in
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/bin
        mv ${path}/macos $out/Applications
        echo "#!${zsh}/bin/zsh" >> $out/bin/${name}
        echo "open -a $out/Applications/${pname}.app" >> $out/bin/${pname}
        chmod +x $out/bin/${pname}
      ''
    else
      ''
        mv ${path}/deb/*/data/usr $out
      '';
  doCheck = false;

  meta = {
    description = "Modern, cross-platform system monitor built on top of Svelte, Rust, and Tauri";
    homepage = "https://abdenasser.github.io/neohtop/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hannesgith ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "neohtop";
  };
}
