# Glance {#module-services-glance}

Glance is a self-hosted dashboard that puts all your feeds in one place.

Visit [the Glance project page](https://github.com/glanceapp/glance) to learn
more about it.

## Quickstart {#module-services-glance-quickstart}

Checkout the [configuration docs](https://github.com/glanceapp/glance/blob/main/docs/configuration.md) to learn more.
Use the following configuration to start a public instance of Glance locally:

```nix
{
  services.glance = {
    enable = true;
    settings = {
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "full";
              widgets = [
                { type = "calendar"; }
                {
                  type = "weather";
                  location = "Nivelles, Belgium";
                }
              ];
            }
          ];
        }
      ];
    };
    openFirewall = true;
  };
}
```
