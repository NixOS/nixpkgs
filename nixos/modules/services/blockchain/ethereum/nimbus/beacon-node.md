# Nimbus Beacon Node {#module-services-nimbus-beacon-node}

## Quick Start {#module-services-nimbus-beacon-node-quick-start}
Nimbus is an extremely efficient consensus layer client implementation.
While it's optimised for embedded systems and resource-restricted devices --
including Raspberry Pis, its low resource usage also makes it an excellent choice
for any server or desktop (where it simply takes up fewer resources).

In order for the [Consensus Layer(CL) client](https://ethereum.org/en/developers/docs/nodes-and-clients/#consensus-clients)
to function it requires access to an [Execution Layer(EL) client](https://ethereum.org/en/developers/docs/nodes-and-clients/#execution-clients)
listening for AuthRPC requests on `http://localhost:8551/`.
An example configuration using Geth as the EL client would look like this:

```nix
# Execution layer client
services.geth.mainnet = {
  enable = true;
  authrpc = {
    enable = true;
    port = 8551;
    vhosts = ["localhost"];
    jwtsecret = "/var/run/geth/jwtsecret";
  };
};

# Consensus layer client
services.nimbus-beacon-node = {
  enable = true;
  web3Urls = ["http://localhost:${toString config.services.geth.mainnet.authrpc.port}"];
  jwtSecret = "/var/run/geth/jwtsecret";
  rest.enable = true;
};
```
::: {.warning}
This assumes you have a `/var/run/geth/jwtsecret` containing a 64 byte secret.
You can create such a secret using `openssl rand -hex 32 | tr -d "\n"`.
:::

This should allow the CL node to communicate with EL node via Auth RPC.

Keep in mind that the JWT secret needs to be the same and readable for both nodes.
If both services run on the same host and listen on `localhost` it's just a formality.

You can check if the node is working using the REST API:

{command}`curl -s localhost:5052/eth/v1/node/version`
```json
{"data":{"version":"Nimbus/v22.9.1-ad286b-stateofus"}}
```
{command}`curl -s localhost:5052/eth/v1/node/syncing`
```json
{"data":{"head_slot":"45102","sync_distance":"4744542","is_syncing":true,"is_optimistic":false}}
```

## Configuration {#module-services-nimbus-beacon-node-configuration}

Other settings worth looking at include:

* {option}`services.nimbus-beacon-node.suggestedFeeRecipient` - Your address for receiving [transaction fees](https://nimbus.guide/suggested-fee-recipient.html).
* {option}`services.nimbus-beacon-node.doppelganger` - Miss two epochs to avoid [validator slashing](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/rewards-and-penalties/#slashing).
* {option}`services.nimbus-beacon-node.metrics.enable` - Prometheus metrics endpoint listening on `9100` by default.
* {option}`services.nimbus-beacon-node.extraArgs` - Ability to provide flags not defined in the service.

For documentation see: <https://nimbus.guide/>
