{ stdenv }:

{ name, exec }:

stdenv.mkDerivation rec {
  dbusName = "dbus-${name}.service";
  buildCommand = ''
    mkdir -p $out/lib/systemd/user
    cat > $out/lib/systemd/user/${dbusName} <<EOF
    [D-BUS Service]
    Name=${name}
    Exec=${exec}
    SystemdService=${dbusName}
    EOF
 '';
}
