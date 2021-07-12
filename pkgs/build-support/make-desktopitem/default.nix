{ lib, runCommandLocal, desktop-file-utils }:

# See https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
{ name # The name of the desktop file
, type ? "Application"
, exec
, icon ? null
, comment ? null
, terminal ? false
, desktopName # The name of the application
, genericName ? null
, mimeType ? null
, categories ? null
, startupNotify ? null
, noDisplay ? null
, prefersNonDefaultGPU ? null
, extraDesktopEntries ? { } # Extra key-value pairs to add to the [Desktop Entry] section. This may override other values
, extraEntries ? "" # Extra configuration. Will be appended to the end of the file and may thus contain extra sections
, fileValidation ? true # whether to validate resulting desktop file.
}:
let
  # like builtins.toString, but null -> null instead of null -> ""
  nullableToString = value:
    if value == null then null
    else if builtins.isBool value then lib.boolToString value
    else builtins.toString value;

  # The [Desktop entry] section of the desktop file, as attribute set.
  mainSection = {
    "Type" = toString type;
    "Exec" = nullableToString exec;
    "Icon" = nullableToString icon;
    "Comment" = nullableToString comment;
    "Terminal" = nullableToString terminal;
    "Name" = toString desktopName;
    "GenericName" = nullableToString genericName;
    "MimeType" = nullableToString mimeType;
    "Categories" = nullableToString categories;
    "StartupNotify" = nullableToString startupNotify;
    "NoDisplay" = nullableToString noDisplay;
    "PrefersNonDefaultGPU" = nullableToString prefersNonDefaultGPU;
  } // extraDesktopEntries;

  # Map all entries to a list of lines
  desktopFileStrings =
    [ "[Desktop Entry]" ]
    ++ builtins.filter
      (v: v != null)
      (lib.mapAttrsToList
        (name: value: if value != null then "${name}=${value}" else null)
        mainSection
      )
    ++ (if extraEntries == "" then [ ] else [ "${extraEntries}" ]);
in
runCommandLocal "${name}.desktop"
{
  nativeBuildInputs = [ desktop-file-utils ];
}
  (''
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/${name}.desktop" <<EOF
    ${builtins.concatStringsSep "\n" desktopFileStrings}
    EOF
  '' + lib.optionalString fileValidation ''
    echo "Running desktop-file validation"
    desktop-file-validate "$out/share/applications/${name}.desktop"
  '')
