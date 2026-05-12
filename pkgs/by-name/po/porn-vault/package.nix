{
  fetchFromGitLab,
  rustPlatform,
  lib,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,
  nodejs_24,
  ffmpeg,
  imagemagick,
  openssl,
  pkg-config,
  makeWrapper,
}:
let
  nodejs = nodejs_24;
  pnpm' = pnpm_10.override { nodejs = nodejs_24; };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "porn-vault";
  version = "0.40.0-beta.30";

  src = fetchFromGitLab {
    owner = "porn-vault";
    repo = "porn-vault";
    rev = "c85e5db5dc9ba9bdbc926fe1393ee2075ae1f22f";
    hash = "sha256-n5kWMmGlFA8iYUK83uRj6zpJ6PW64Ivy2ywPNZQ8yeY=";
  };

  cargoHash = "sha256-E5Oq+aLUT+jMuspIs+CFnKBtJTTgq7GlB1VU+9m9caY=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    prePatch = ''
      cd app
    '';
    pnpm = pnpm';
    fetcherVersion = 3;
    hash = "sha256-8g5JDcZ/GIeIiFEwrxS0w5oi3K7yJHtE08ljrUlFFo0=";
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
