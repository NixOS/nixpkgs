# Livebook {#module-services-livebook}

[Livebook](https://livebook.dev/) is a web application for writing
interactive and collaborative code notebooks.

## Basic Usage {#module-services-livebook-basic-usage}

Enabling the `livebook` service creates a user
[`systemd`](https://www.freedesktop.org/wiki/Software/systemd/) unit
which runs the server.

```
{ ... }:

{
  services.livebook = {
    enableUserService = true;
    environment = {
      LIVEBOOK_PORT = 20123;
      LIVEBOOK_PASSWORD = "mypassword";
    };
    # See note below about security
    environmentFile = "/var/lib/livebook.env";
  };
}
```

::: {.note}

The Livebook server has the ability to run any command as the user it
is running under, so securing access to it with a password is highly
recommended.

Putting the password in the Nix configuration like above is an easy way to get
started but it is not recommended in the real world because the resulting
environment variables can be read by unprivileged users.  A better approach
would be to put the password in some secure user-readable location and set
`environmentFile = /home/user/secure/livebook.env`.

:::

The [Livebook
documentation](https://hexdocs.pm/livebook/readme.html#environment-variables)
lists all the applicable environment variables. It is recommended to at least
set `LIVEBOOK_PASSWORD` or `LIVEBOOK_TOKEN_ENABLED=false`.

### Extra dependencies {#module-services-livebook-extra-dependencies}

By default, the Livebook service is run with minimum dependencies, but
some features require additional packages.  For example, the machine
learning Kinos require `gcc` and `gnumake`.  To add these, use
`extraPackages`:

```
services.livebook.extraPackages = with pkgs; [ gcc gnumake ];
```
