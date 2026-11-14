{
  lib,
  runCommand,
  libei,
  python3,
  dbus,
  xdg-desktop-portal,
  eitype,
}:
let
  server = libei.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      install -Dm755 tools/eis-demo-server $out/bin/eis-demo-server
    '';
  });
  python = python3.withPackages (ps: [ ps.dbus-next ]);
  test =
    portal:
    runCommand "eitype-${if portal then "portal" else "socket"}-test"
      {
        nativeBuildInputs = [ python ] ++ lib.optionals portal [ dbus ];
      }
      ''
        export HOME="$TMPDIR"
        export XDG_RUNTIME_DIR="$TMPDIR/runtime"
        export XDG_CACHE_HOME="$TMPDIR/cache"
        mkdir -m700 "$XDG_RUNTIME_DIR"
        unset LIBEI_SOCKET

        ${lib.optionalString portal "dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf --"} python ${./.}/test.py \
          ${lib.getExe eitype} ${server}/bin/eis-demo-server \
          ${lib.optionalString portal "--portal ${xdg-desktop-portal}/libexec/xdg-desktop-portal"}
        touch "$out"
      '';
in
{
  socket = test false;
  portal = test true;
}
