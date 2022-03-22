from urllib.request import urlopen

client.wait_for_unit("multi-user.target")
server.wait_for_unit("multi-user.target")

server.succeed("echo Hello > file")
server.succeed("python -m http.server 8080 >&2 &")
server.wait_for_open_port(8080)

with subtest("simple"):
    client.wait_until_succeeds("curl http://server:8080/file | grep Hello")

with subtest("block"):
    server.block()
    client.fail("curl --max-time 5 http://server:8080/file")

with subtest("unblock"):
    server.unblock()
    client.succeed("curl http://server:8080/file")

with subtest("forward_port"):
    server.forward_port(8888, 8080)
    response = urlopen("http://localhost:8888/file").read()
    assert response == b"Hello\n", f"unexpected response {response}"
