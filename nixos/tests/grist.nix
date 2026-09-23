{ pkgs, ... }:
let
  forwardedPort = 8484;
  internalPort = 8484;
in
{
  name = "grist smoke test";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        virtualisation.forwardPorts = [
          {
            host.port = forwardedPort;
            guest.port = internalPort;
          }
        ];

        networking.firewall.allowedTCPPorts = [ 8484 ];

        services.grist = {
          enable = true;
          enableRedis = true;
          environment = {
            APP_HOME_URL = "http://127.0.0.1:8484";
            GRIST_IN_SERVICE = "true";
            GRIST_BOOT_KEY = "dummy";
            GRIST_HOST = "0.0.0.0";
            DEBUG = "1";
          };
        };
      };
  };

  extraPythonPackages = p: [
    p.requests
  ];

  testScript = ''
    import requests
    import sys

    start_all()

    machine.wait_for_unit("grist-core.service")
    machine.wait_for_open_port(${builtins.toString internalPort})

    url = "http://127.0.0.1:${builtins.toString forwardedPort}/o/docs/api/"

    def check_answer(r):
      if not r.ok:
        sys.exit(1)
      return r.json()

    with subtest("Create document"):
      r = requests.post(f"{url}docs", json = {"timezone":"Europe/Paris"})
      doc_id = check_answer(r)

    with subtest("Create table"):
      r = requests.post(f"{url}docs/{doc_id}/tables", json={
        "tables": [
          {
            "id": "double",
            "columns": [
              {
                "id": "number",
                "fields": {
                  "type": "Numeric",
                  "label": "Number",
                },
              },
              {
                "id": "result",
                "fields": {
                  "type": "Numeric",
                  "label": "Result",
                  "formula": "$number * 2",
                  "isFormula": True,
                },
              },
            ],
          },
        ],
      })
      table_id = check_answer(r)["tables"][0]["id"]

    with subtest("Add record"):
      r = requests.post(f"{url}docs/{doc_id}/tables/{table_id}/records", json={
        "records": [
          {
            "fields": {
              "number": 5,
            },
          },
        ],
      })
      if len(check_answer(r)) != 1:
        sys.exit(1)

    with subtest("Read record"):
      r = requests.get(f"{url}docs/{doc_id}/tables/{table_id}/records")
      record = check_answer(r)["records"][0]
      if record["fields"]["result"] != record["fields"]["number"] * 2:
        sys.exit(1)
  '';
}
