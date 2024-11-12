# OCS Inventory Agent {#module-services-ocsinventory-agent}

[OCS Inventory NG](https://ocsinventory-ng.org/) or Open Computers and Software inventory
is an application designed to help IT administrator to keep track of the hardware and software
configurations of computers that are installed on their network.

OCS Inventory collects information about the hardware and software of networked machines
through the **OCS Inventory Agent** program.

This NixOS module enables you to install and configure this agent so that it sends information from your computer to the OCS Inventory server.

For more technical information about OCS Inventory Agent, refer to [the Wiki documentation](https://wiki.ocsinventory-ng.org/03.Basic-documentation/Setting-up-the-UNIX-agent-manually-on-client-computers/).


## Basic Usage {#module-services-ocsinventory-agent-basic-usage}

A minimal configuration looks like this:

```nix
{
  services.ocsinventory-agent = {
    enable = true;
    settings = {
      server = "https://ocsinventory.localhost:8080/ocsinventory";
      tag = "01234567890123";
    };
  };
}
```

This configuration will periodically run the ocsinventory-agent SystemD service.

The OCS Inventory Agent will inventory the computer and then sends the results to the specified OCS Inventory Server.
