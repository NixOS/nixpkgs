import json
import queue
import subprocess
import sys
import threading


def main():
    with subprocess.Popen(
        [sys.argv[1], "--demo"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
    ) as process:
        events = queue.Queue()

        def read():
            for line in process.stdout:
                events.put(json.loads(line))

        reader = threading.Thread(target=read, daemon=True)
        reader.start()
        pending = []

        def send(command):
            process.stdin.write(json.dumps({"protocolVersion": 1, **command}) + "\n")
            process.stdin.flush()

        def wait_for(predicate):
            for index, event in enumerate(pending):
                if predicate(event):
                    return pending.pop(index)
            for _ in range(100):
                event = events.get(timeout=5)
                assert event["protocolVersion"] == 1, event
                if predicate(event):
                    return event
                pending.append(event)
            raise AssertionError("expected protocol event was not emitted")

        try:
            send({"op": "config", "generation": 1})
            wait_for(
                lambda event: event["ev"] == "phase" and event["phase"] == "connected"
            )
            states = wait_for(lambda event: event["ev"] == "states")
            lights = [
                entity
                for entity in states["entities"]
                if entity["entity_id"].startswith("light.")
            ]
            assert lights, states
            target_state = "off" if lights[0]["state"] == "on" else "on"
            send(
                {
                    "op": "call_service",
                    "generation": 1,
                    "domain": "light",
                    "service": f"turn_{target_state}",
                    "entity_id": lights[0]["entity_id"],
                    "tag": "packaged-light",
                }
            )
            result = wait_for(
                lambda event: (
                    event["ev"] == "result" and event.get("tag") == "packaged-light"
                )
            )
            assert result["ok"], result
            changed = wait_for(
                lambda event: (
                    event["ev"] == "state_changed"
                    and event["entity"]["entity_id"] == lights[0]["entity_id"]
                )
            )
            assert changed["entity"]["state"] == target_state, changed
        finally:
            process.stdin.close()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
            reader.join(timeout=1)
        assert process.returncode == 0, process.returncode


if __name__ == "__main__":
    main()
