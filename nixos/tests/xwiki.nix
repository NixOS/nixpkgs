{ pkgs, ... }:
{
  name = "xwiki";

  nodes.machine = {
    services.xwiki = {
      enable = true;
      rootWebapp = true;
      database = {
        type = "hsqldb";
      };
    };

    services.tomcat.port = 8080;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("tomcat.service")
    machine.wait_for_open_port(8080)
    print(machine.succeed("curl -sS --connect-timeout 5 --max-time 180 -D /tmp/xwiki-headers.txt -o /tmp/xwiki-body.html http://localhost:8080/ || true"))
    print(machine.succeed("""
      for i in $(seq 1 120); do
        curl -sS --connect-timeout 5 --max-time 60 -D /tmp/xwiki-redirect-headers.txt -o /tmp/xwiki-redirect-body.html http://localhost:8080/bin/view/Main/ || true
        code="$(awk 'toupper($1) ~ /^HTTP\\// { c=$2 } END { print c }' /tmp/xwiki-redirect-headers.txt)"
        location="$(awk 'BEGIN { IGNORECASE = 1 } /^Location:/ { sub(/^Location:[[:space:]]*/, ""); print; exit }' /tmp/xwiki-redirect-headers.txt)"
        echo "attempt=$i code=$code location=$location"
        if [ "$code" != "202" ] || [ -n "$location" ]; then
          break
        fi
        sleep 2
      done
      test "$code" != "202"
    """))
    print(machine.succeed("echo '==== headers ===='; cat /tmp/xwiki-headers.txt || true"))
    print(machine.succeed("echo '==== body (full begin) ===='; cat /tmp/xwiki-body.html || true; echo '==== body (full end) ===='"))
    print(machine.succeed("echo '==== redirect headers ===='; cat /tmp/xwiki-redirect-headers.txt || true"))
    print(machine.succeed("echo '==== redirect body (full begin) ===='; cat /tmp/xwiki-redirect-body.html || true; echo '==== redirect body (full end) ===='"))
    print(machine.succeed("ls -la /var/tomcat/logs"))
    print(machine.succeed("""
      for f in /var/tomcat/logs/*; do
        [ -f "$f" ] || continue
        echo "==== $f ===="
        tail -n 200 "$f" || true
      done
    """))

    machine.succeed("test -s /tmp/xwiki-headers.txt")
    machine.succeed("test -s /tmp/xwiki-redirect-headers.txt")
  '';
}
