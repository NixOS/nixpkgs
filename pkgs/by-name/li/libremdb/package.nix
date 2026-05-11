{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libremdb";
  version = "4.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zyachel";
    repo = finalAttrs.pname;
    rev = "d0793f59b5f090fe0d29341e3a173cfa92884307";
    hash = "sha256-zJHX+mZ22dhtkWuwh9k8f6lmChTN2VnsQNolvb0WAOo=";
  };

  patches = [
    ./add-packages-field.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version;
    src = stdenv.mkDerivation {
      name = "${finalAttrs.pname}-patched-src";
      inherit (finalAttrs) src patches;
      installPhase = "cp -r . $out";
    };
    pnpm = pnpm_9;
    fetcherVersion = 2;
    hash = "sha256-+oH3nF3vdjJ+vlPapPo2hJh3bDlogXoku/JRZJbssKA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9
    pnpmConfigHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${finalAttrs.pname}
    cp -r .next public package.json node_modules $out/share/${finalAttrs.pname}/

    makeWrapper ${nodejs}/bin/node $out/bin/${finalAttrs.pname} \
      --add-flags "$out/share/${finalAttrs.pname}/node_modules/next/dist/bin/next" \
      --add-flags "start" \
      --add-flags "$out/share/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = {
    description = "Free and open source IMDb frontend";
    longDescription = ''
      Privacy-respecting alternative frontend for IMDb, allowing users to browse
      movie and television information without ads or tracking.
    '';
    homepage = "https://libremdb.iket.me";
    changelog = "https://github.com/zyachel/libremdb/blob/main/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "libremdb";
    platforms = lib.platforms.all;
  };
})
