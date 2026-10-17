import json
import os
from pathlib import Path
import select
import struct
import subprocess
import sys


package = Path(sys.argv[1])
build_commit = sys.argv[2]

runtime_environment = {
    "GST_PLUGIN_PATH": "",
    "GST_PLUGIN_PATH_1_0": "",
    "GST_PLUGIN_SYSTEM_PATH": "",
    "GST_PLUGIN_SYSTEM_PATH_1_0": "",
    "GST_REGISTRY": "/dev/null",
    "GST_REGISTRY_UPDATE": "no",
    "GST_REGISTRY_FORK": "no",
}


def frame(message: dict[str, object]) -> bytes:
    payload = json.dumps(message, separators=(",", ":")).encode()
    return struct.pack(">I", len(payload)) + payload


def read_exact(stream: subprocess.Popen[bytes], size: int) -> bytes:
    output = bytearray()
    assert stream.stdout is not None
    while len(output) < size:
        readable, _, _ = select.select([stream.stdout], [], [], 10)
        if not readable:
            raise TimeoutError("voice helper response timed out")
        chunk = os.read(stream.stdout.fileno(), size - len(output))
        if not chunk:
            raise EOFError("voice helper exited before replying")
        output.extend(chunk)
    return bytes(output)


def exchange(stream: subprocess.Popen[bytes], message: dict[str, object]) -> object:
    assert stream.stdin is not None
    stream.stdin.write(frame(message))
    stream.stdin.flush()
    length = struct.unpack(">I", read_exact(stream, 4))[0]
    return json.loads(read_exact(stream, length))


environment = os.environ.copy()
environment.update(runtime_environment)
process = subprocess.Popen(
    [package / "codex-resources/voice/bin/codex-voice-host"],
    cwd=package,
    env=environment,
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    bufsize=0,
)
assert exchange(
    process, {"type": "hello", "protocol": 1, "buildCommit": build_commit}
) == {"type": "ready"}
assert exchange(process, {"type": "initializeRuntime"}) == {"type": "runtimeReady"}
assert exchange(process, {"type": "close"}) == {"type": "closed"}
assert process.stdin is not None
assert process.stderr is not None
process.stdin.close()
status = process.wait(timeout=10)
assert status == 0, process.stderr.read().decode(errors="replace")
