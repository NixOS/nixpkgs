{
  fetchFromGitLab,
  rustPlatform,
  lib,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,
  nodejs_26,
  nodejs-slim_26,
  ffmpeg,
  imagemagick,
  openssl,
  pkg-config,
  makeWrapper,
}:
let
  nodejs = nodejs_26;
  nodejs-slim = nodejs-slim_26;
  pnpm' = pnpm_11.override { inherit nodejs-slim; };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "porn-vault";
  version = "0.40.7";

  src = fetchFromGitLab {
    owner = "porn-vault";
    repo = "porn-vault";
    tag = finalAttrs.version;
    hash = "sha256-Q0q6esEYh989BZD3iFyF+iYBHv+Lh8k/EAdmPd8gMLI=";
  };

  cargoHash = "sha256-7juoF4I/OD8NRwBvKAnAwberJQ4RZqBh+rbtIjff90I=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    prePatch = ''
      cd app
    '';
    pnpm = pnpm';
    fetcherVersion = 4;
    hash = "sha256-M1Vg5WYSO2aM7aObvNLt1n1pqOzh/78QmHxsCI5IX44=";
  };

  nativeBuildInputs = [
    pkg-config
    openssl
    nodejs
    pnpmConfigHook
    pnpm'
    makeWrapper
  ];

  prePnpmInstall = ''
    cd app
  '';

  postPatch = ''
    substituteInPlace vault/src/temp.rs \
      --replace-fail 'PV_TMP_FOLDER' "CACHE_DIRECTORY"
  '';

  preBuild = ''
    pnpm build
  '';

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  doCheck = false;

  installPhase = ''
    runHook preInstall

    cd ..
    mkdir -p $out/bin
    cp ./target/${stdenv.hostPlatform.config}/release/pv $out/bin/porn-vault-unwrapped

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper "$out/bin/porn-vault-unwrapped" "$out/bin/porn-vault" \
      --prefix PATH : "${
        lib.makeBinPath [
          ffmpeg
          imagemagick
          openssl
        ]
      }"
  '';

  meta = {
    description = "Self-hosted organizer for adult videos and imagery";
    homepage = "https://gitlab.com/porn-vault/porn-vault";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.luNeder ];
    inherit (nodejs.meta) platforms;
    mainProgram = "porn-vault";
  };
})
