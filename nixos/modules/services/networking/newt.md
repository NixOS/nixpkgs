# Newt {#module-services-newt}

Newt is a tunneling client for [Pangolin](https://digpangolin.com/). It is designed to securely expose private resources as orchestrated by a Pangolin server. It is the client component of the [Fossorial stack](https://docs.fossorial.io/Getting%20Started/overview#system-diagram).

It does not use stateful configuration files; the module simply wraps Newt inside a sandboxed systemd service and uses the Newt command-line flags or environment variables to configure a connection to a Pangolin instance. Thus, this module acts as a more robust alternative to the `nix-shell` commands suggested in the Pangolin dashboard.

To set it up, create a file owned by `root` and with permissions `700` to store the `NEWT_SECRET` environment variable. It can also contain other environment variables, like `NEWT_ID` or `PANGOLIN_ENDPOINT` if you wish to set `services.newt.id` and `services.newt.endpoint` to `null`. Below is an example of the environment file's syntax:

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
    # Since our environment file contains the NEWT_ID and PANGOLIN_ENDPOINT variables, both of the options below could be set to null.
    endpoint = "https://pangolin.example.test";
    id = "2ix2t8xk22ubpfy";
  };
}
```

After rebuilding, the `newt.service` systemd unit should be running and connected to the specified Pangolin instance.

See the [upstream documentation](https://docs.fossorial.io/Newt/overview) for more information on Newt.
