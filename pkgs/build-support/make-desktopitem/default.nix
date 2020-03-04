{ lib, runCommandLocal }:
{ name
, type ? "Application"
, exec
, icon ? null
, comment ? null
, terminal ? "false"
, desktopName
, genericName ? null
, mimeType ? null
, categories ? "Application;Other;"
, startupNotify ? null
, extraEntries ? null
}:

let
  optionalEntriesList = [{k="Icon";          v=icon;}
                         {k="Comment";       v=comment;}
                         {k="GenericName";   v=genericName;}
                         {k="MimeType";      v=mimeType;}
                         {k="StartupNotify"; v=startupNotify;}];

  valueNotNull = {k, v}: v != null;
  entriesToKeep = builtins.filter valueNotNull optionalEntriesList;

  mkEntry = {k, v}:  k + "=" + v;
  optionalEntriesString  = lib.concatMapStringsSep "\n" mkEntry entriesToKeep;
in
runCommandLocal "${name}.desktop" {}
  ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/${name}.desktop <<EOF
    [Desktop Entry]
    Type=${type}
    Exec=${exec}
    Terminal=${terminal}
    Name=${desktopName}
    Categories=${categories}
    ${optionalEntriesString}
    ${if extraEntries == null then ''EOF'' else ''
    ${extraEntries}
    EOF''}
  ''
