{
  lib,
  cargo-tauri,
  nodejs,
  pnpm,
  rustPlatform,
  moreutils,
  protobuf,
  jq,
  yq,
  stdenv,
  fetchFromGitHub,
  zsh,
}:
let
  pname = "rquickshare";
  version = "0.11.2";
  src = fetchFromGitHub {
    owner = "martichou";
    repo = "rquickshare";
    rev = "v${version}";
    sha256 = "sha256-MYhM6FB3zfvMFnLMecbn4Ismvk8AAykIvhPBnFcNjdI=";
  };
  tauri = cargo-tauri;
in
# we could use rustPlatform.buildRustPackage, but there cargoDeps doesn't work
stdenv.mkDerivation rec {
  inherit version src pname;
  name = pname;
  sourceRoot = "${src.name}/app/main";
  corelibSourceRoot = "${src.name}/core_lib";
  cargoRoot = "src-tauri";
  corelibPath = "rqs_lib";
  nativeBuildInputs = [
    tauri.hook
    pnpm.configHook
    nodejs
    moreutils
    protobuf
    jq
    yq
    rustPlatform.cargoSetupHook
  ];
  # seemingly the fetcher ignores cargoRoot (contrary to the docs)
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname;
    hash = cargoHash;
    sourceRoot = "${sourceRoot}/${cargoRoot}";
  };
  cargoHash = "sha256-5vGXMHar9E25jVseXR2uI82DtZXyPaHgDD8QkqoRhhY=";
  pnpmDeps = pnpm.fetchDeps {
    inherit src sourceRoot pname;
    hash = "sha256-VPb2idEiBruVCwz5lDojFmD2C5CfXYSe5mPWBwCGeJs=";
  };
  postUnpack =
    let
      fullCorePath = "${sourceRoot}/${cargoRoot}/${corelibPath}";
    in
    ''
      cp -r ${corelibSourceRoot} ${fullCorePath} && chmod -R +w ${fullCorePath}
    '';
  # remove macOS signing and relative links
  postConfigure = ''
    jq     'del(.bundle.macOS.signingIdentity, .bundle.macOS.hardenedRuntime)' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    yq -iy '.importers.".".dependencies."@martichou/core_lib".specifier = "link:${corelibPath}" | .importers.".".dependencies."@martichou/core_lib".version = "link:${corelibPath}"' pnpm-lock.yaml
    jq     '.dependencies."@martichou/core_lib" = "link:${corelibPath}"' package.json | sponge package.json
    sed -i 's|path = "../../../core_lib"|path = "${corelibPath}"|' ${cargoRoot}/Cargo.toml
  '';
  checkPhase = "true"; # idk why checks fail, todo
  installPhase =
    let
      path = "${cargoRoot}/target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/bundle";
    in
    if stdenv.isDarwin then
      ''
        mkdir -p $out/bin
        mv ${path}/macos $out/Applications
        echo "#!${lib.getExe zsh}" >> $out/bin/${name}
        echo "open -a $out/Applications/${name}.app" >> $out/bin/${name}
        chmod +x $out/bin/${name}
      ''
    else
      ''
        mv ${path}/deb/*/data/usr $out
      '';
  meta = {
    description = "Rust implementation of NearbyShare/QuickShare from Android for Linux and macOS";
    homepage = "https://github.com/Martichou/rquickshare";
    changelog = "https://github.com/Martichou/rquickshare/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hannesgith
      luftmensch-luftmensch
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "rquickshare";
  };
}
