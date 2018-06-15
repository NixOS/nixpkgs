{stdenv}:
{ name
, type ? "Application"
, exec
, icon ? ""
, comment ? ""
, terminal ? "false"
, desktopName
, genericName
, mimeType ? ""
, categories ? "Application;Other;"
, startupNotify ? null
, extraEntries ? ""
}:

stdenv.mkDerivation {
  name = "${name}.desktop";
  buildCommand = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/${name}.desktop <<EOF
    [Desktop Entry]
    Type=${type}
    Exec=${exec}
    Icon=${icon}
    Comment=${comment}
    Terminal=${terminal}
    Name=${desktopName}
    GenericName=${genericName}
    MimeType=${mimeType}
    Categories=${categories}
    ${extraEntries}
    ${if startupNotify == null then ''EOF'' else ''
    StartupNotify=${startupNotify}
    EOF''}
  '';
}
