# Glances {#module-serives-glances}

Glances an Eye on your system. A top/htop alternative for GNU/Linux, BSD, Mac OS
and Windows operating systems.

Visit [the Glances project page](https://github.com/nicolargo/glances) to learn
more about it.

# Quickstart {#module-serives-glances-quickstart}

Use the following configuration to start a public instance of Glances locally:

```nix
{
  services.glances = {
    enable = true;
    openFirewall = true;
  };
}
```
