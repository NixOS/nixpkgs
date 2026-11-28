{
  lib,
  callPackage,
  symlinkJoin,
  makeWrapper,
  nix-update-script,
  _experimental-update-script-combinators,

  stalwartEnterprise ? false,
  withBundledWebui ? true,
  withBundledSpamFilter ? false,
}:
let
  unwrapped = callPackage ./unwrapped.nix { inherit stalwartEnterprise; };
  webui = callPackage ./webui.nix { };
  spam-filter = callPackage ./spam-filter.nix { };
in
# a separate wrapper, so that an update of the web interface or the spam
# filter rules does not rebuild stalwart
symlinkJoin {
  pname = lib.removeSuffix "-unwrapped" unwrapped.pname;
  inherit (unwrapped) version;

  paths = [ unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/stalwart \
      ${lib.optionalString withBundledWebui "--set-default STALWART_WEBUI_URL file://${webui}/webui.zip"} \
      ${lib.optionalString withBundledSpamFilter "--set-default STALWART_SPAM_FILTER_URL file://${spam-filter}/spam-filter-rules.json.gz"}

    # start the wrapper, not the unwrapped binary
    rm $out/lib/systemd/system/stalwart.service
    substitute ${unwrapped.src}/resources/systemd/stalwart-mail.service $out/lib/systemd/system/stalwart.service \
      --replace-fail "__PATH__" "$out"
  '';

  passthru = {
    inherit unwrapped webui spam-filter;
    inherit (unwrapped) rocksdb; # make used rocksdb version available (e.g., for backup scripts)
    # subpackages have distinct version numbers, so we can't use nix-update's `--subpackage`
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { attrPath = "stalwart_1.unwrapped"; })
      (nix-update-script { attrPath = "stalwart_1.webui"; })
      (nix-update-script { attrPath = "stalwart_1.spam-filter"; })
    ];
  };

  inherit (unwrapped) meta;
}
