{
  stdenv,
  fetchFromGitHub,
  nodejs,
  buildNpmPackage,
  vips,
  pkg-config,
  writeShellApplication,
  xxd,
  openssl,
  lib,
}:

let
  generateSecrets = writeShellApplication {
    name = "generate-pds-secrets";

    runtimeInputs = [
      xxd
      openssl
    ];

    # Commands from https://github.com/bluesky-social/pds/blob/8b9fc24cec5f30066b0d0b86d2b0ba3d66c2b532/installer.sh
    text = ''
      echo "PDS_JWT_SECRET=$(openssl rand --hex 16)"
      echo "PDS_ADMIN_PASSWORD=$(openssl rand --hex 16)"
      echo "PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX=$(openssl ecparam --name secp256k1 --genkey --noout --outform DER | tail --bytes=+8 | head --bytes=32 | xxd --plain --cols 32)"
    '';
  };
in

# NOTE: Package comes with `pnpm-lock.yaml` but we cannot use `pnpm.fetchDeps` here because it
# does not work with `sharp` NPM dependency that needs `vips` and `pkg-config`
# Regenerate `package-lock.json` with `npm i --package-lock-only`
buildNpmPackage (rec {
  pname = "pds";
  version = "0.4.59";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "pds";
    rev = "v${version}";
    hash = "sha256-E4SoaLvDaHqOtZ2yExjyK6Z7Bkah6BsCFJd7cvxSwM4=";
  };

  sourceRoot = "${src.name}/service";

  npmDepsHash = "sha256-UP2BdxLxHoE9VN8YJPq3IjThpliRbevBeiBzTE5QGI0=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  # Required for `sharp` NPM dependency
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ vips ];

  buildPhase = ''
    runHook preBuild

    cat <<EOF >> pds.sh
    ${nodejs}/bin/node --enable-source-maps ${placeholder "out"}/lib/pds/index.js
    EOF
    chmod +x pds.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/pds}
    mv node_modules $out/lib/pds
    mv index.js $out/lib/pds
    mv pds.sh $out/bin/pds

    runHook postInstall
  '';

  passthru = {
    inherit generateSecrets;
  };

  meta = {
    description = "Bluesky Personal Data Server (PDS)";
    homepage = "https://bsky.social";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.unix;
    mainProgram = "pds";
  };
})
