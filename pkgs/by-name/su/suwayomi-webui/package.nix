# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@nanoyaki.space>
#
# SPDX-License-Identifier: MIT
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs_22,
  husky,
  tsx,
  _experimental-update-script-combinators,
  nix-update-script,

  nodejs ? nodejs_22,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suwayomi-webui";
  version = "20250801.01";
  revision = "2717";

  src = fetchFromGitHub {
    owner = "Suwayomi";
    repo = "Suwayomi-WebUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-42upfz3KQmP9VnzoFmo+vHuZVdbv1/viQZW1rz0ex4E=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-UtAje6A0VmzcBEf/J0JUvRKxLaUKeXEjyGHJa9LIb3k=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook

    nodejs
    husky
    tsx
  ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "project" "suwayomi-webui" \
      --replace-fail "22.12.0" "${nodejs.version}"
  '';

  postBuild = ''
    yarn --offline build-md5
    echo "r${finalAttrs.revision}" > build/revision
  '';

  installPhase = ''
    runHook preInstall

    cp -a build $out
    mv buildZip/md5sum $out

    runHook postInstall
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    {
      command = [
        ./update-rev.sh
        finalAttrs.src.rev
      ];
    }
  ];

  meta = {
    description = "The default client for Suwayomi-Server";
    homepage = "https://github.com/Suwayomi/Suwayomi-WebUI";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-WebUI/releases/";
    changelog = "https://github.com/Suwayomi/Suwayomi-WebUI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    inherit (nodejs.meta) platforms;
    maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
  };
})
