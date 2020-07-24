{ lib, runCommandLocal, desktop-file-utils }:

{ name
, type ? "Application"
, exec
, icon ? null
, comment ? null
, terminal ? "false"
, desktopName
, genericName ? null
, mimeType ? null
, categories ? null
, startupNotify ? null
, extraEntries ? null
, fileValidation ? true # whether to validate resulting desktop file.
}:

let
  optionalEntriesList = [{k="Icon";          v=icon;}
                         {k="Comment";       v=comment;}
                         {k="GenericName";   v=genericName;}
                         {k="MimeType";      v=mimeType;}
                         {k="Categories";    v=categories;}
                         {k="StartupNotify"; v=startupNotify;}];

  valueNotNull = {k, v}: v != null;
  entriesToKeep = builtins.filter valueNotNull optionalEntriesList;

  mkEntry = {k, v}:  k + "=" + v;
  optionalEntriesString  = lib.concatMapStringsSep "\n" mkEntry entriesToKeep;
in
runCommandLocal "${name}.desktop" {}
  ''
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/${name}.desktop" <<EOF
    [Desktop Entry]
    Type=${type}
    Exec=${exec}
    Terminal=${terminal}
    Name=${desktopName}
    ${optionalEntriesString}
    ${if extraEntries == null then ''EOF'' else ''
    ${extraEntries}
    EOF''}

    ${lib.optionalString fileValidation ''
      echo "Running desktop-file validation"
      ${desktop-file-utils}/bin/desktop-file-validate "$out/share/applications/${name}.desktop"
    ''}
  ''
