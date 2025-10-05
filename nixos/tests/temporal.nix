(
  { lib, pkgs, ... }:

  {
    name = "temporal";
    meta.maintainers = [ pkgs.lib.maintainers.jpds ];

    nodes = {
      temporal =
        { config, pkgs, ... }:
        {
          networking.firewall.allowedTCPPorts = [ 7233 ];

          environment.systemPackages = [
            (pkgs.writers.writePython3Bin "temporal-hello-workflow.py"
              {
                libraries = [ pkgs.python3Packages.temporalio ];
              }
              # Graciously taken from https://github.com/temporalio/samples-python/blob/main/hello/hello_activity.py
              ''
                import asyncio
                from concurrent.futures import ThreadPoolExecutor
                from dataclasses import dataclass
                from datetime import timedelta

                from temporalio import activity, workflow
                from temporalio.client import Client
                from temporalio.worker import Worker


                # While we could use multiple parameters in the activity, Temporal strongly
                # encourages using a single dataclass instead which can have fields added to it
                # in a backwards-compatible way.
                @dataclass
                class ComposeGreetingInput:
                    greeting: str
                    name: str


                # Basic activity that logs and does string concatenation
                @activity.defn
                def compose_greeting(input: ComposeGreetingInput) -> str:
                    activity.logger.info("Running activity with parameter %s" % input)
                    return f"{input.greeting}, {input.name}!"


                # Basic workflow that logs and invokes an activity
                @workflow.defn
                class GreetingWorkflow:
                    @workflow.run
                    async def run(self, name: str) -> str:
                        workflow.logger.info("Running workflow with parameter %s" % name)
                        return await workflow.execute_activity(
                            compose_greeting,
                            ComposeGreetingInput("Hello", name),
                            start_to_close_timeout=timedelta(seconds=10),
                        )


                async def main():
                    # Uncomment the lines below to see logging output
                    # import logging
                    # logging.basicConfig(level=logging.INFO)

                    # Start client
                    client = await Client.connect("localhost:7233")

                    # Run a worker for the workflow
                    async with Worker(
                        client,
                        task_queue="hello-activity-task-queue",
                        workflows=[GreetingWorkflow],
                        activities=[compose_greeting],
                        # Non-async activities require an executor;
                        # a thread pool executor is recommended.
                        # This same thread pool could be passed to multiple workers if desired.
                        activity_executor=ThreadPoolExecutor(5),
                    ):

                        # While the worker is running, use the client to run the workflow and
                        # print out its result. Note, in many production setups, the client
                        # would be in a completely separate process from the worker.
                        result = await client.execute_workflow(
                            GreetingWorkflow.run,
                            "World",
                            id="hello-activity-workflow-id",
                            task_queue="hello-activity-task-queue",
                        )
                        print(f"Result: {result}")


                if __name__ == "__main__":
                    asyncio.run(main())
              ''
            )
            pkgs.temporal-cli
          ];

          services.temporal = {
            enable = true;
            settings = {
              # Based on https://github.com/temporalio/temporal/blob/main/config/development-sqlite.yaml
              log = {
                stdout = true;
                level = "info";
              };
              services = {
                frontend = {
                  rpc = {
                    grpcPort = 7233;
                    membershipPort = 6933;
                    bindOnLocalHost = true;
                    httpPort = 7243;
                  };
                };
                matching = {
                  rpc = {
                    grpcPort = 7235;
                    membershipPort = 6935;
                    bindOnLocalHost = true;
                  };
                };
                history = {
                  rpc = {
                    grpcPort = 7234;
                    membershipPort = 6934;
                    bindOnLocalHost = true;
                  };
                };
                worker = {
                  rpc = {
                    grpcPort = 7239;
                    membershipPort = 6939;
                    bindOnLocalHost = true;
                  };
                };
              };

              persistence = {
                defaultStore = "sqlite-default";
                visibilityStore = "sqlite-visibility";
                numHistoryShards = 1;
                datastores = {
                  sqlite-default = {
                    sql = {
                      user = "";
                      password = "";
                      pluginName = "sqlite";
                      databaseName = "default";
                      connectAddr = "localhost";
                      connectProtocol = "tcp";
                      connectAttributes = {
                        mode = "memory";
                        cache = "private";
                      };
                      maxConns = 1;
                      maxIdleConns = 1;
                      maxConnLifetime = "1h";
                      tls = {
                        enabled = false;
                        caFile = "";
                        certFile = "";
                        keyFile = "";
                        enableHostVerification = false;
                        serverName = "";
                      };
                    };
                  };
                  sqlite-visibility = {
                    sql = {
                      user = "";
                      password = "";
                      pluginName = "sqlite";
                      databaseName = "default";
                      connectAddr = "localhost";
                      connectProtocol = "tcp";
                      connectAttributes = {
                        mode = "memory";
                        cache = "private";
                      };
                      maxConns = 1;
                      maxIdleConns = 1;
                      maxConnLifetime = "1h";
                      tls = {
                        enabled = false;
                        caFile = "";
                        certFile = "";
                        keyFile = "";
                        enableHostVerification = false;
                        serverName = "";
                      };
                    };
                  };
                };
              };
              clusterMetadata = {
                enableGlobalNamespace = false;
                failoverVersionIncrement = 10;
                masterClusterName = "active";
                currentClusterName = "active";
                clusterInformation = {
                  active = {
                    enabled = true;
                    initialFailoverVersion = 1;
                    rpcName = "frontend";
                    rpcAddress = "localhost:7233";
                    httpAddress = "localhost:7243";
                  };
                };
              };

              dcRedirectionPolicy = {
                policy = "noop";
              };

              archival = {
                history = {
                  state = "enabled";
                  enableRead = true;
                  provider = {
                    filestore = {
                      fileMode = "0666";
                      dirMode = "0766";
                    };
                    gstorage = {
                      credentialsPath = "/tmp/gcloud/keyfile.json";
                    };
                  };
                };
                visibility = {
                  state = "enabled";
                  enableRead = true;
                  provider = {
                    filestore = {
                      fileMode = "0666";
                      dirMode = "0766";
                    };
                  };
                };
              };

              namespaceDefaults = {
                archival = {
                  history = {
                    state = "disabled";
                    URI = "file:///tmp/temporal_archival/development";
                  };
                  visibility = {
                    state = "disabled";
                    URI = "file:///tmp/temporal_vis_archival/development";
                  };
                };
              };
            };
          };
        };
    };

    testScript = ''
      temporal.wait_for_unit("temporal")
      temporal.wait_for_open_port(6933)
      temporal.wait_for_open_port(6934)
      temporal.wait_for_open_port(6935)
      temporal.wait_for_open_port(7233)
      temporal.wait_for_open_port(7234)
      temporal.wait_for_open_port(7235)

      temporal.wait_until_succeeds(
        "journalctl -o cat -u temporal.service | grep 'server-version' | grep '${pkgs.temporal.version}'"
      )

      temporal.wait_until_succeeds(
        "journalctl -o cat -u temporal.service | grep 'Frontend is now healthy'"
      )

      import json
      cluster_list_json = json.loads(temporal.wait_until_succeeds("temporal operator cluster list --output json"))
      assert cluster_list_json[0]['clusterName'] == "active"

      cluster_describe_json = json.loads(temporal.wait_until_succeeds("temporal operator cluster describe --output json"))
      assert cluster_describe_json['serverVersion'] in "${pkgs.temporal.version}"

      temporal.log(temporal.wait_until_succeeds("temporal operator namespace create --namespace default"))

      temporal.wait_until_succeeds(
        "journalctl -o cat -u temporal.service | grep 'Register namespace succeeded'"
      )

      namespace_list_json = json.loads(temporal.wait_until_succeeds("temporal operator namespace list --output json"))
      assert len(namespace_list_json) == 2

      namespace_describe_json = json.loads(temporal.wait_until_succeeds("temporal operator namespace describe --output json --namespace default"))
      assert namespace_describe_json['namespaceInfo']['name'] == "default"
      assert namespace_describe_json['namespaceInfo']['state'] == "NAMESPACE_STATE_REGISTERED"

      workflow_json = json.loads(temporal.wait_until_succeeds("temporal workflow list --output json"))
      assert len(workflow_json) == 0

      out = temporal.wait_until_succeeds("temporal-hello-workflow.py")
      assert "Result: Hello, World!" in out

      workflow_json = json.loads(temporal.wait_until_succeeds("temporal workflow list --output json"))
      assert workflow_json[0]['execution']['workflowId'] == "hello-activity-workflow-id"
      assert workflow_json[0]['status'] == "WORKFLOW_EXECUTION_STATUS_COMPLETED"

      temporal.log(temporal.succeed(
        "systemd-analyze security temporal.service | grep -v '✓'"
      ))
    '';
  }
)
