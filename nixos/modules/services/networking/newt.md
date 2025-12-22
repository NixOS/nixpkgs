# Newt {#module-services-newt}

Newt is a tunneling client for [Pangolin](https://pangolin.net/). It is designed to securely expose private resources as orchestrated by a Pangolin server. It is the client component of the [Pangolin stack](https://docs.pangolin.net/).

It does not use stateful configuration files; the module simply wraps Newt inside a sandboxed systemd service and uses the Newt command-line flags or environment variables to configure a connection to a Pangolin instance. Thus, this module acts as a more robust alternative to the `nix-shell` commands suggested in the Pangolin dashboard.

To set it up, create a file owned by `root` with permissions `700` to store the {env}`NEWT_SECRET` environment variable. This file may contain other environment variables, like {env}`NEWT_ID` or {env}`PANGOLIN_ENDPOINT`. This removes the need for setting the Newt ID and endpoint in your NixOS configuration via the {option}`services.newt.settings` option, and keeps them out of the Nix Store. Below is an example of the environment file's syntax:

```bash
NEWT_SECRET=nnisrfsdfc7prqsp9ewo1dvtvci50j5uiqotez00dgap0ii2
NEWT_ID=2ix2t8xk22ubpfy
PANGOLIN_ENDPOINT=https://pangolin.example.test
```

Those credentials can be found during site generation in the Pangolin dashboard. Once a site is created, these credentials are not shown again. After setting up the environment file, the following can be added to the NixOS configuration:

```nix
{
  services.newt = {
    enable = true;
    environmentFile = "/var/lib/secrets/newt.env"
    settings = {
      log-level = "DEBUG";
      mtu = 1280;
      ping-timeout = "10s";
      # You can also set up the ID, endpoint and secret via the `settings`
      # option, but this will cause them to be leaked in the Nix Store:
      # id = "2ix2t8xk22ubpfy";
      # endpoint = "https://pangolin.example.test";
      # secret = "nnisrfsdfc7prqsp9ewo1dvtvci50j5uiqotez00dgap0ii2";
    };
  };
}
```

After rebuilding, the `newt.service` systemd unit should be running and connected to the specified Pangolin instance.

See the [upstream documentation](https://docs.pangolin.net/manage/sites/configure-site) for more information on Newt.
