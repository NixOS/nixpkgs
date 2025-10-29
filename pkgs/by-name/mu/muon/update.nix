{
  lib,
  writeShellApplication,
  common-updater-scripts,
  curl,
  gnugrep,
}:

lib.getExe (writeShellApplication {
  name = "update-muon";

  runtimeInputs = [
    common-updater-scripts
    curl
    gnugrep
  ];

  text = ''
    REPO=$(nix-instantiate --raw --eval -E "with import ./. {}; muon.srcsAttrs.muon-src.meta.homepage")
    MUON_VERSION=$(list-git-tags --url="$REPO" | tail -1)

    update-source-version "muon" \
      "$MUON_VERSION" \
      --version-key=version \
      --source-key=srcsAttrs.muon-src
    update-source-version "muon" \
      "$(curl -s "$REPO/blob/$MUON_VERSION/subprojects/meson-docs.wrap" | grep -oP "revision = \K.+$")" \
      --version-key=srcsAttrs.meson-docs.rev \
      --source-key=srcsAttrs.meson-docs
    update-source-version "muon" \
      "$(curl -s "$REPO/blob/$MUON_VERSION/subprojects/meson-tests.wrap" | grep -oP "revision = \K.+$")" \
      --version-key=srcsAttrs.meson-tests.rev \
      --source-key=srcsAttrs.meson-tests
  '';
})
