# Send a log event through the OTLP pipeline and check for its
# presence in the collector logs.
import requests
import time

from uuid import uuid4

flag = str(uuid4())

# Can be replaced by regex
port = 4318

machine.wait_for_unit("opentelemetry-collector.service")
machine.wait_for_open_port(port)

event = {
    "resourceLogs": [
        {
            "resource": {"attributes": []},
            "scopeLogs": [
                {
                    "logRecords": [
                        {
                            "timeUnixNano": str(time.time_ns()),
                            "severityNumber": 9,
                            "severityText": "Info",
                            "name": "logTest",
                            "body": {
                                "stringValue": flag
                            },
                            "attributes": []
                        },
                    ]
                }
            ]
        }
    ]
}

response = requests.post(f"http://localhost:{port}/v1/logs", json=event)
assert response.status_code == 200
assert flag in machine.execute("journalctl -u opentelemetry-collector")[-1]
