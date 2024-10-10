# Reposilite {#module-services-reposilite}

Reposilite is a self-hosted repository manager for Maven based artifacts in JVM ecosystem.

Visit [the Reposilite project page](https://reposilite.com) to learn
more about it.

## Quickstart {#module-services-reposilite-quickstart}

Use the following configuration to start a public instance of Reposilite locally:

```nix
{
  services.reposilite = {
    enable = true;
    settings = {
      sslEnabled = true;
    };
    openFirewall = true;
  };
}
```

## Generating a Token {#module-services-reposilite-generating-a-token}

You'll need to generate your first access token on the CLI (after which you can generate them in the web UI):

```
sudo systemctl stop reposilite.service
reposilite --working-directory /var/lib/reposilite --port 8084 --database "sqlite reposilite.db" --token <tokenName:tokenSecret>
```

If you have modified the `database` option, update the flag in the command above as such.

This creates a temporary token. With the server still running, access the web dashboard in a browser at `localhost:8084`, and create a permanent token by navigating to the `Console` tab and typing:

```
token-generate <name>
```

This will output a secret which you should save. You can then Ctrl-C to kill the Reposilite process and run the following command to restart the systemd service:

```
sudo systemctl start reposilite.service
```
