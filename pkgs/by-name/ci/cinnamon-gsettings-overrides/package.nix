{
  lib,
  runCommand,
  glib,
  gnome-terminal,
  gtk3,
  gsettings-desktop-schemas,
  extraGSettingsOverrides ? "",
  extraGSettingsOverridePackages ? [ ],
  mint-artwork,

  muffin,
  nemo,
  xapp,
  cinnamon-desktop,
  cinnamon-session,
  cinnamon-settings-daemon,
  cinnamon,
  bulky,
}:

let

  inherit (lib) concatMapStringsSep;

  gsettingsOverridePackages = [
    # from
    mint-artwork

    # on
    bulky
    muffin
    nemo
    xapp
    cinnamon-desktop
    cinnamon-session
    cinnamon-settings-daemon
    cinnamon
    gnome-terminal
    gsettings-desktop-schemas
    gtk3
  ]
  ++ extraGSettingsOverridePackages;

  gsettingsOverrides = ''
    # Use Fedora's default to make text readable and
    # restore ununified menu.
    # https://github.com/NixOS/nixpkgs/issues/200017
    [org.gnome.Terminal.Legacy.Settings]
    theme-variant='dark'
    unified-menu=false

    ${extraGSettingsOverrides}
  '';
in

# TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
runCommand "cinnamon-gsettings-overrides" { } ''
  data_dir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
  schema_dir="$data_dir/glib-2.0/schemas"

  mkdir -p "$schema_dir"

  ${concatMapStringsSep "\n" (
    pkg:
    "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"${glib.getSchemaPath pkg}\"/*.gschema.override \"$schema_dir\""
  ) gsettingsOverridePackages}

  chmod -R a+w "$data_dir"

  cat - > "$schema_dir/nixos-defaults.gschema.override" <<- EOF
  ${gsettingsOverrides}
  EOF

  ${glib.dev}/bin/glib-compile-schemas --strict "$schema_dir"
''
