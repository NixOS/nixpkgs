{ lib, writeTextFile, desktop-file-utils }:

# All possible values as defined by the spec, version 1.4.
# Please keep in spec order for easier maintenance.
# When adding a new value, don't forget to update the Version field below!
# See https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
{ name # The name of the desktop file
, type ? "Application"
# version is hardcoded
, desktopName # The name of the application
, genericName ? null
, noDisplay ? null
, comment ? null
, icon ? null
# we don't support the Hidden key - if you don't need something, just don't install it
, onlyShowIn ? []
, notShowIn ? []
, dbusActivatable ? null
, tryExec ? null
, exec ? null
, path ? null
, terminal ? null
, actions ? {} # An attrset of [internal name] -> { name, exec?, icon? }
, mimeTypes ? [] # The spec uses "MimeType" as singular, use plural here to signify list-ness
, categories ? []
, implements ? []
, keywords ? []
, startupNotify ? null
, startupWMClass ? null
, url ? null
, prefersNonDefaultGPU ? null
# not supported until version 1.5, which is not supported by our desktop-file-utils as of 2022-02-23
# , singleMainWindow ? null
, extraConfig ? {} # Additional values to be added literally to the final item, e.g. vendor extensions
}:
let
  # FIXME: workaround until https://github.com/NixOS/nixpkgs/pull/162246 lands
  cleanName = if lib.hasInfix " " name
                then throw "Name must not contain spaces!"
                else name;

  # There are multiple places in the FDO spec that make "boolean" values actually tristate,
  # e.g. StartupNotify, where "unset" is literally defined as "do something reasonable".
  # So, handle null values separately.
  boolOrNullToString = value:
    if value == null then null
    else if builtins.isBool value then lib.boolToString value
    else throw "Value must be a boolean or null!";

  # Multiple values are represented as one string, joined by semicolons.
  # Technically, it's possible to escape semicolons in values with \;, but this is currently not implemented.
  renderList = value:
    if !builtins.isList value then throw "Value must be a list!"
    else if builtins.any (item: lib.hasInfix ";" item) value then throw "Values in list must not contain semicolons!"
    else if value == [] then null
    else builtins.concatStringsSep ";" value;

  # The [Desktop Entry] section of the desktop file, as an attribute set.
  # Please keep in spec order.
  mainSection = {
    "Type" = type;
    "Version" = "1.4";
    "Name" = desktopName;
    "GenericName" = genericName;
    "NoDisplay" = boolOrNullToString noDisplay;
    "Comment" = comment;
    "Icon" = icon;
    "OnlyShowIn" = renderList onlyShowIn;
    "NotShowIn" = renderList notShowIn;
    "DBusActivatable" = boolOrNullToString dbusActivatable;
    "TryExec" = tryExec;
    "Exec" = exec;
    "Path" = path;
    "Terminal" = boolOrNullToString terminal;
    "Actions" = renderList (builtins.attrNames actions);
    "MimeType" = renderList mimeTypes;
    "Categories" = renderList categories;
    "Implements" = renderList implements;
    "Keywords" = renderList keywords;
    "StartupNotify" = boolOrNullToString startupNotify;
    "StartupWMClass" = startupWMClass;
    "URL" = url;
    "PrefersNonDefaultGPU" = boolOrNullToString prefersNonDefaultGPU;
    # "SingleMainWindow" = boolOrNullToString singleMainWindow;
  } // extraConfig;

  # Render a single attribute pair to a Key=Value line.
  # FIXME: this isn't entirely correct for arbitrary strings, as some characters
  # need to be escaped. There are currently none in nixpkgs though, so this is OK.
  renderLine = name: value: if value != null then "${name}=${value}" else null;

  # Render a full section of the file from an attrset.
  # Null values are intentionally left out.
  renderSection = sectionName: attrs:
    lib.pipe attrs [
      (lib.mapAttrsToList renderLine)
      (builtins.filter (v: !isNull v))
      (builtins.concatStringsSep "\n")
      (section: ''
        [${sectionName}]
        ${section}
      '')
    ];

  mainSectionRendered = renderSection "Desktop Entry" mainSection;

  # Convert from javaCase names as used in Nix to PascalCase as used in the spec.
  preprocessAction = { name, icon ? null, exec ? null }: {
    "Name" = name;
    "Icon" = icon;
    "Exec" = exec;
  };
  renderAction = name: attrs: renderSection "Desktop Action ${name}" (preprocessAction attrs);
  actionsRendered = lib.mapAttrsToList renderAction actions;

  content = [ mainSectionRendered ] ++ actionsRendered;
in
writeTextFile {
  name = "${cleanName}.desktop";
  destination = "/share/applications/${cleanName}.desktop";
  text = builtins.concatStringsSep "\n" content;
  checkPhase = "${desktop-file-utils}/bin/desktop-file-validate $target";
}
