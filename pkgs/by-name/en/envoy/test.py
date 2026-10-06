import http.server
import json
import pathlib
import subprocess
import tempfile
import threading
import time
import urllib.error
import urllib.request


class Upstream(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello through Envoy!\n")


with http.server.ThreadingHTTPServer(("127.0.0.1", 0), Upstream) as upstream:
    threading.Thread(target=upstream.serve_forever, daemon=True).start()
    config = f"""
admin:
  address:
    socket_address: {{address: 127.0.0.1, port_value: 0}}
static_resources:
  listeners:
  - name: http
    address:
      socket_address: {{address: 127.0.0.1, port_value: 0}}
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          stat_prefix: test
          route_config:
            virtual_hosts:
            - name: upstream
              domains: ["*"]
              routes:
              - match: {{prefix: "/"}}
                route: {{cluster: upstream}}
          http_filters:
          - name: envoy.filters.http.router
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
  clusters:
  - name: upstream
    connect_timeout: 1s
    type: STATIC
    load_assignment:
      cluster_name: upstream
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address: {{address: 127.0.0.1, port_value: {upstream.server_port}}}
"""
    with tempfile.TemporaryDirectory() as tmp:
        admin_path = pathlib.Path(tmp) / "admin-address"
        args = ["envoy", "--disable-hot-restart", "--config-yaml", config]
        subprocess.run(args + ["--mode", "validate"], check=True)
        process = subprocess.Popen(
            args + ["--concurrency", "1", "--admin-address-path", str(admin_path)]
        )
        try:
            deadline = time.monotonic() + 30
            while not admin_path.exists() or not admin_path.read_text().strip():
                assert process.poll() is None, (
                    "Envoy exited before starting its admin listener"
                )
                assert time.monotonic() < deadline, "Envoy startup timed out"
                time.sleep(0.1)
            opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
            admin_url = "http://" + admin_path.read_text().strip()
            while True:
                try:
                    with opener.open(admin_url + "/ready", timeout=1) as response:
                        assert response.status == 200
                    break
                except (urllib.error.URLError, TimeoutError):
                    assert process.poll() is None, "Envoy exited before becoming ready"
                    assert time.monotonic() < deadline, "Envoy readiness timed out"
                    time.sleep(0.1)
            with opener.open(
                admin_url + "/listeners?format=json", timeout=10
            ) as response:
                listeners = json.load(response)
            port = listeners["listener_statuses"][0]["local_address"]["socket_address"][
                "port_value"
            ]
            with opener.open(f"http://127.0.0.1:{port}/", timeout=10) as response:
                assert response.read() == b"Hello through Envoy!\n"
        finally:
            process.terminate()
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
    upstream.shutdown()
