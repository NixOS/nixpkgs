{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  ffmpeg,
  makeWrapper,
  nixosTests,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bookorbit";
  version = "3.5.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bookorbit";
    repo = "bookorbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eaTt8om4thzmfpCrj3+Vfq/rkl0AhqRM/mcNc59b7wI=";
  };

  pnpmWorkspaces = [
    "client..."
    "server..."
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-0sKhAlLsIZEEB0Xlt5xs3yvAmgqGSFACHpGir/DYSpM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    ffmpeg
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    # @swc/core >= 1.16 ships its native addon as a self-loading ELF carrier
    # with a zstd "SWCNZSTD" payload embedded in a read-only section. On load
    # the addon self-extracts into a per-user cache and refuses to load unless
    # that cache root *and every one of its ancestors* is owned by the
    # effective uid or root and is not group/other-writable
    # (crates/swc_native_addon/src/platform/unix.rs, secure_cache_root). The
    # nix sandbox root "/" is owned by an unmapped uid, so no
    # SWC_NATIVE_BINDING_CACHE location can satisfy the check, and the
    # SWC_NATIVE_BINDING_CACHE_SKIP_SECURITY_CHECK opt-out only exists in
    # @swc/core >= 1.16.17. Overwrite each carrier with its decoded raw addon:
    # the raw N-API addon loads directly, exactly as pre-1.16 swc shipped it.
    # The payload lives in a read-only section as a v1 header (magic, version
    # 1, 96-byte header size) followed by the raw addon as a zstd frame.
    find node_modules -name 'swc.*.node' -exec node -e '
      const fs = require("node:fs"), z = require("node:zlib");
      const signature = Buffer.from("SWCNZSTD\x01\x00\x60\x00", "latin1");
      for (const p of process.argv.slice(1)) {
        const b = fs.readFileSync(p);
        const i = b.indexOf(signature);
        if (i < 0) continue;
        const frameLen = Number(b.readBigUInt64LE(i + 16));
        const raw = z.zstdDecompressSync(b.subarray(i + 96, i + 96 + frameLen));
        fs.chmodSync(p, 0o644);
        fs.writeFileSync(p, raw);
      }
    ' {} +

    # ora's spinner hangs in the non-TTY sandbox without CI set.
    export CI=1
    pnpm --filter client run build-only
    pnpm --filter server run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    pnpm --filter server \
         --config.inject-workspace-packages=true \
         --prod \
         deploy $out/lib

    cp -r client/dist $out/lib/public
    cp -r server/src/db/migrations $out/lib/migrations
    cp -r koreader-plugin $out/lib/koreader-plugin

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit \
      --run "cd $out/lib" \
      --set NODE_ENV production \
      --set APP_VERSION ${finalAttrs.version} \
      --add-flags "$out/lib/dist/main.js"

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit-migrate \
      --set NODE_ENV production \
      --add-flags "$out/lib/dist/scripts/migrate.js"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) bookorbit;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "BookOrbit, self-hosted library management and reading platform for ebooks, PDFs, audiobooks, and comics.";
    homepage = "https://github.com/bookorbit/bookorbit";
    changelog = "https://github.com/bookorbit/bookorbit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ iv-nn ];
    mainProgram = "bookorbit";
    platforms = lib.platforms.all;
  };
})
