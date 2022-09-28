# Nim Waku {#module-services-nwaku}

## Quick Start {#module-services-nwaku-quick-start}

To start a basic node with store, relay, filter, swap, and lightpush procotols enabled,
connected to the main [Status.im](https://status.im/) fleet use:

```nix
services.nwaku = {
  enable = true;
  tcpPort = 8888;
  protocols = ["store" "relay" "filter" "swap" "lightpush"];
  nodekey = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234";
  nat = "extip:12.34.56.78";
  rest = {
    enable = true;
    admin = true;
    port = 5052;
  };
  dnsDiscovery = {
    enable = true;
    url = "enrtree://AOGECG2SPND25EEFMAJ5WF3KSGJNSGV356DSTL2YVLLZWIV6SAYBM@prod.nodes.status.im";
  };
  storeMessage = {
    retentionPolicy = "time:${toString (7*24*60*60)}"; # 7 days
  };
};
```
This node will store 30 days worth of messages it will receive under `/var/run/nwaku`.

You can check the node addresses using the REST API:

{command}`curl -sSf localhost:5052/debug/v1/info`
```json
{
  "listenAddresses": [
    "/ip4/12.34.56.78/tcp/8888/p2p/16Uiu2HAmDFsM5S7fTaaDpc2BYdE6nqSoR7mg5ou2R73fJRrELMiT"
  ],
  "enrUri": "enr:-Iu4QCKaz_TAPebEcvjx3VonobqeGXpnrI4HcYHwmncekzrIV6Y9QfCnnU4xC_5f5KprFak0VBgYteb1UjJJGaYxVJsBgmlkgnY0"
}
```
