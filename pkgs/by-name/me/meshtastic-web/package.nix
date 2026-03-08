{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meshtastic-web";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-71/Wr/b42fknVCdeO99AI4ZpJk8Smkse/TFisKLzBCQ=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  pnpmWorkspaces = [ "*" ];
  pnpmRoot = "packages/web";
  pnpmDeps = fetchPnpmDeps {
    pnpm = pnpm_9;
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 2;
    hash = "sha256-p8AdAYqaHoKaWirNy9uPLs/kRDVNDcXBJQ1y29MVAA0=";
  };

  nativeBuildInputs = [
    pnpm_9
    pnpmConfigHook
    nodejs
  ];

  preConfigure = ''
    substituteInPlace packages/web/vite.config.ts \
      --replace-fail "hash = \"DEV\"" "hash = \"$(cat COMMIT)\"" \
      --replace-fail "version = \"v0.0.0\"" "version = \"${finalAttrs.version}\""
  '';

  buildPhase = ''
    runHook preBuild

    pushd packages/web
    pnpm install
    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar dist/. $out/

    runHook postInstall
  '';

  meta = {
    description = "Meshtastic Web Client/JS Monorepo";
    homepage = "https://github.com/meshtastic/web";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
