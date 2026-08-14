{
  lib,
  symlinkJoin,
  makeWrapper,
  anki,
  anki-utils,
  writeTextDir,
  ankiAddons ? [ ],
}:
/*
  `ankiAddons`
   :  A set of Anki add-ons to be installed. Here's a an example:

      ~~~
      pkgs.anki.withAddons [
        # When the add-on is already available in nixpkgs
        pkgs.ankiAddons.anki-connect

        # When the add-on is not available in nixpkgs
        (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
          pname = "recolor";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AnKing-VIP";
            repo = "AnkiRecolor";
            rev = finalAttrs.version;
            sparseCheckout = [ "src/addon" ];
            hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
          };
          sourceRoot = "source/src/addon";
        }))

        # When the add-on needs to be configured
        pkgs.ankiAddons.passfail2.withConfig {
          config = {
            again_button_name = "not quite";
            good_button_name = "excellent";
          };

          user_files = ./dir-to-be-merged-into-addon-user-files-dir;
        };
      ]
      ~~~

      The original `anki` executable will be wrapped so that it uses the addons from
      `ankiAddons`.

      This only works with Anki versions patched to support the `ANKI_ADDONS` environment
      variable. `pkgs.anki` has this, but `pkgs.anki-bin` does not.
*/
let
  defaultAddons = [
    (anki-utils.buildAnkiAddon {
      pname = "nixos";
      version = "1.0";
      src = writeTextDir "__init__.py" ''
        import builtins
        import io
        import json
        from pathlib import Path
        import aqt
        from aqt.qt import QMessageBox

        ADDONS_PATH = Path(aqt.mw.addonManager.addonsFolder()).expanduser().absolute()


        def addons_dialog_will_show(dialog: aqt.addons.AddonsDialog) -> None:
          dialog.setEnabled(False)
          QMessageBox.information(
            dialog,
            "NixOS Info",
            ("These add-ons are managed by NixOS.<br>"
             "See <a href='https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/an/anki/with-addons.nix'>"
             "github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/an/anki/with-addons.nix</a>")
          )

        def addon_tried_to_write_config(module: str, conf: dict) -> None:
          message_box = QMessageBox(
            QMessageBox.Icon.Warning,
            "NixOS Info",
            (f"The add-on module: \"{module}\" tried to update its config.<br>"
              "See <a href='https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/an/anki/with-addons.nix'>"
              "github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/an/anki/with-addons.nix</a>"
              " for how to configure add-ons managed by NixOS.")
          )
          message_box.setDetailedText(json.dumps(conf))
          message_box.exec()


        class _InterceptedWrite(io.StringIO):
          def __init__(self, path: str):
            super().__init__()
            self.path = path

          def close(self):
            if self.closed:
              return
            text = self.getvalue()
            super().close()
            message_box = QMessageBox(
              QMessageBox.Icon.Warning,
              "NixOS Info",
              (f"An attempt was made to write to the user_file at {self.path}<br>"
                "See <a href='https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/an/anki/with-addons.nix'>"
                "github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/an/anki/with-addons.nix</a>"
                " for how to configure add-ons managed by NixOS."
              ),
            )
            message_box.setDetailedText(text)
            message_box.exec()


        def open_hook(real_open, file, mode="r", *args, **kwargs):
          target = Path(file).expanduser().absolute()
          base_path = Path(ADDONS_PATH).expanduser().absolute()
          if target.is_relative_to(base_path):
            parts = target.relative_to(base_path).parts
            is_user_file = len(parts) >= 2 and parts[1] == "user_files"
            if is_user_file and any(m in mode for m in "wax+"):
              return _InterceptedWrite(file)
          return real_open(file, mode, *args, **kwargs)


        def builtin_open_hook(file, mode="r", *args, **kwargs):
            return open_hook(_real_builtin_open, file, mode, *args, **kwargs)


        def io_open_hook(file, mode="r", *args, **kwargs):
            return open_hook(_real_io_open, file, mode, *args, **kwargs)


        aqt.gui_hooks.addons_dialog_will_show.append(addons_dialog_will_show)
        aqt.mw.addonManager.writeConfig = addon_tried_to_write_config

        _real_builtin_open = builtins.open
        _real_io_open = io.open
        builtins.open = builtin_open_hook
        io.open = io_open_hook
      '';
      meta.maintainers = with lib.maintainers; [ junestepp ];
    })
  ];
in
symlinkJoin {
  inherit (anki) version;
  pname = "${anki.pname}-with-addons";

  paths = [ anki ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/anki \
      --set ANKI_ADDONS "${anki-utils.buildAnkiAddonsDir (ankiAddons ++ defaultAddons)}"
  '';

  meta = removeAttrs anki.meta [
    "name"
    "outputsToInstall"
    "position"
  ];
}
