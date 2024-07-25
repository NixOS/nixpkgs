{
  stdenv,
  fetchFromGitHub,
  lib,
  pnpm_9,
  nodejs,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "suncord";
  version = "0-unstable-2024-07-23";

  src = fetchFromGitHub {
    owner = "verticalsync";
    repo = "Suncord";
    rev = "f445680d06928538542d116fc98ce8244b3b79b4";
    hash = "sha256-SE0VTjRrDxJgjhURyYyB5uF4PzZwwNoj2LrgRHRAgNs=";
  };

  strictDeps = true;
  dontStrip = true;

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QkXxQtCa8HX9G6M+Hgu6EEY1ZCyShiUWS0s8zKbMq98=";
  };

  SUNCORD_HASH = finalAttrs.src.rev;
  SUNCORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm ${if buildWebExtension then "buildWeb" else "build"} \
    --standalone \
    --disable-updater \
    --legacy-peer-deps

    runHook postBuild
  '';

  installPhase = ''

    runHook preInstall
    ${
      if buildWebExtension then
        ''
          cp -r dist/chromium-unpacked $out
        ''
      else
        ''
          cp -r dist/ $out
        ''
    }
    runHook postInstall
  '';

  meta = {
    description = "A fork of Vencord";
    homepage = "https://github.com/verticalsync/Suncord";
    license = lib.licenses.gpl3Only;
    platforms = nodejs.meta.platforms;
    maintainers = with lib.maintainers; [ nicekoishi ];
  };
})
