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

# Password protection {#module-serives-glances-password-protection}

Protect the web and server interfaces with a password by pointing
{option}`services.glances.passwordFile` at a file containing the plain-text
password, for example as provided by [sops-nix](https://github.com/Mic92/sops-nix)
or [agenix](https://github.com/ryantm/agenix):

```nix
{
  services.glances = {
    enable = true;
    passwordFile = config.sops.secrets."glances/password".path;
  };
}
```

At startup the module reads the password from the secret file, hashes it and
stores the hash in a runtime directory that only the service can read. Clients
authenticate with {option}`services.glances.username` (default `glances`) and
the password.
