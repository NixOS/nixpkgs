{
  name = "trilium-server";
  nodes = {
    default = {
      services.trilium-server.enable = true;
    };
    configured = {
      services.trilium-server = {
        enable = true;
        dataDir = "/data/trilium";
      };
    };

    nginx = {
      services.trilium-server = {
        enable = true;
        nginx.enable = true;
        nginx.hostName = "trilium.example.com";
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("by default works without configuration"):
        default.wait_for_unit("trilium-server.service")

    with subtest("by default available on port 8080"):
        default.wait_for_unit("trilium-server.service")
        default.wait_for_open_port(8080)
        # we output to /dev/null here to avoid a python UTF-8 decode error
        # but the check will still fail if the service doesn't respond
        default.succeed("curl --fail -o /dev/null 127.0.0.1:8080")

    with subtest("by default creates empty document"):
        default.wait_for_unit("trilium-server.service")
        default.succeed("test -f /var/lib/trilium/document.db")

    with subtest("configured with custom data store"):
        configured.wait_for_unit("trilium-server.service")
        configured.succeed("test -f /data/trilium/document.db")

    with subtest("nginx with custom host name"):
        nginx.wait_for_unit("trilium-server.service")
        nginx.wait_for_unit("nginx.service")

        nginx.succeed(
            "curl --resolve 'trilium.example.com:80:127.0.0.1' http://trilium.example.com/"
        )
  '';
}
