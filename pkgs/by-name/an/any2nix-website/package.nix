{
  bun,
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
}:
let
  pname = "any2nix-website";
  version = "0.1.8";
  src = fetchFromGitHub {
    owner = "gbr-ufs";
    repo = "any2nix";
    tag = "${pname}-v${version}";
    hash = "sha256-RfRxb1nSWbrLBt1/Pqu4wcqPlNac94J6GhtwWUzqxYg=";
  };
  node_modules = stdenvNoCC.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version;
    src = "${src}/any2nix-website";
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];
    dontConfigure = true;
    dontFixup = true;
    buildPhase = ''
      bun install --frozen-lockfile --no-progress
    '';
    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/
    '';
    outputHash = "sha256-uQwopz6lzrGXXFezOtG/z+WUSUQxnP0GTHLAIazcBqw=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;
  __structuredAttrs = true;
  cargoHash = "sha256-k+7FXcyn5hdW3da9xFMePaZZ90ET3zrq0HtSHgGdS0I=";
  buildAndTestSubdir = "any2nix-website";
  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];
  preBuild = ''
    cp -r --no-preserve=mode ${node_modules}/node_modules any2nix-website/
    cd any2nix-website
    bun build assets/js/index.js --outdir dist --minify
    bun build assets/css/index.css --outdir dist --minify
    rm -rf node_modules
    cd ..
  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Web interface for translating from various formats to Nix.";
    homepage = "https://github.com/gbr-ufs/any2nix";
    changelog = "https://github.com/gbr-ufs/any2nix/raw/${finalAttrs.pname}-v${finalAttrs.version}/${finalAttrs.pname}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
    ];
    mainProgram = "any2nix-website";
    maintainers = [
      lib.maintainers."gbr-ufs"
    ];
  };
})
