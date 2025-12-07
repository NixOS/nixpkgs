{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  makeDesktopItem,
  nodejs,
  bun,
  electron,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "geforce-infinity";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "AstralVixen";
    repo = "GeForce-Infinity";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha1-ykUer2I43+GhKCWI8PlvJkE2KmU=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-TQjRwRc2TKqcBVCygJx43+pejKOjTZBfa0Lfz9kZ0Wk=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    makeWrapper

    nodejs
    bun
  ];

  desktopEntry = makeDesktopItem {
    name = "geforce-infinity";
    desktopName = "Geforce Infinity";
    exec = "geforce-infinity";
    icon = "geforce-infinity";
  };

  postInstall = ''
    cp -r dist $out/dist

    mkdir -p $out/share/{applications,icons}
    # copyDesktopItem didn't do its job
    cp "$desktopEntry/share/applications/geforce-infinity.desktop" $out/share/applications
    cp "$out/dist/assets/resources/infinitylogo.png" "$out/share/icons/geforce-infinity.png"

    mv $out/lib/node_modules/${finalAttrs.pname}/node_modules $out
    rm -rf $out/lib

    makeWrapper ${electron}/bin/electron $out/bin/${finalAttrs.pname} \
      --add-flags $out/dist/electron/main.js
  '';

  meta = {
    description = "A next-gen application designed to enhance the GeForce NOW experience.";
    homepage = "https://geforce-infinity.xyz/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ penzboti ];
  };
})
