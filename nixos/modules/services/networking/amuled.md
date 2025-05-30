# aMule {#module-services-amule}

[aMule](https://www.amule.org/) is a free and open-source peer-to-peer file sharing client that supports the eD2k and Kad networks.
It allows users to search for, download, and share files with others on these networks.
The `amuled` daemon is the command-line version of aMule, designed to run as a background service without a graphical user interface, making it suitable for servers or headless systems.
It handles finding sources, managing download and upload queues, and interacting with the eD2k servers and Kad network.

Here a minimal working example:

```nix
services.amule = {
  enable = true;
  ECPasswordFile = "/run/secrets/ECPasswordFile";
};
```

You can connect using `amulegui` and choosing the host, port and password, the username is always `amule`.
