{
  lib,
  rustPlatform,
  pkg-config,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "skwd-lens";
  version = "1.0.0-beta.26";

  src = fetchFromGitHub {
    owner = "liixini";
    repo = "skwd-lens";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c1Us8RDlVub7gUK/7AQ5G+pxUR9/b2HUadxTMcdTBaI=";
  };

  cargoHash = "sha256-HjSd+0CXiyPT6UrBrt+rI+o4tyVMGNRKiX/zPZ/qOe0=";

  nativeBuildInputs = [
    pkg-config
  ];

  cargoBuildFlags = [
    "--manifest-path"
    "Cargo.toml"
    "--package"
    "skwd-lens"
  ];

  cargoTestFlags = [
    "--manifest-path"
    "Cargo.toml"
    "--package"
    "skwd-lens"
  ];

  postInstall = ''
    mkdir -p $out/share/licenses/skwd-lens/third-party

    cp -r $src/LICENSES/* $out/share/licenses/skwd-lens/third-party/
    cp -r $src/LICENSE $out/share/licenses/skwd-lens/
  '';

  meta = {
    description = "Optional semantic wallpaper search engine for Skwd";
    homepage = "https://github.com/liixini/skwd-wall";
    license = with lib.licenses; [
      mit
      asl20
      cc-by-40
    ];
    maintainers = with lib.maintainers; [
      futurekismo
      HomieDerPrakti
    ];
    mainProgram = "skwd-lens";
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

})
