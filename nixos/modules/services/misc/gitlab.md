# GitLab {#module-services-gitlab}

GitLab is a feature-rich git hosting service.

## Prerequisites {#module-services-gitlab-prerequisites}

The `gitlab` service exposes only an Unix socket at
`/run/gitlab/gitlab-workhorse.socket`. You need to
configure a webserver to proxy HTTP requests to the socket.

For instance, the following configuration could be used to use nginx as
frontend proxy:

```nix
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."git.example.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
        proxyWebsockets = true;
      };
    };
  };
}
```

## Configuring {#module-services-gitlab-configuring}

GitLab depends on both PostgreSQL and Redis and will automatically enable
both services. In the case of PostgreSQL, a database and a role will be
created.

The default state dir is `/var/gitlab/state`. This is where
all data like the repositories and uploads will be stored.

A basic configuration with some custom settings could look like this:

```nix
{
  services.gitlab = {
    enable = true;
    databasePasswordFile = "/var/keys/gitlab/db_password";
    initialRootPasswordFile = "/var/keys/gitlab/root_password";
    https = true;
    host = "git.example.com";
    port = 443;
    user = "git";
    group = "git";
    smtp = {
      enable = true;
      address = "localhost";
      port = 25;
    };
    secrets = {
      dbFile = "/var/keys/gitlab/db";
      secretFile = "/var/keys/gitlab/secret";
      otpFile = "/var/keys/gitlab/otp";
      jwsFile = "/var/keys/gitlab/jws";
    };
    extraConfig = {
      gitlab = {
        email_from = "gitlab-no-reply@example.com";
        email_display_name = "Example GitLab";
        email_reply_to = "gitlab-no-reply@example.com";
        default_projects_features = {
          builds = false;
        };
      };
    };
  };
}
```

If you're setting up a new GitLab instance, generate new
secrets. You for instance use
`tr -dc A-Za-z0-9 < /dev/urandom | head -c 128 > /var/keys/gitlab/db` to
generate a new db secret. Make sure the files can be read by, and
only by, the user specified by
[services.gitlab.user](#opt-services.gitlab.user). GitLab
encrypts sensitive data stored in the database. If you're restoring
an existing GitLab instance, you must specify the secrets secret
from `config/secrets.yml` located in your GitLab
state folder.

When `incoming_mail.enabled` is set to `true`
in [extraConfig](#opt-services.gitlab.extraConfig) an additional
service called `gitlab-mailroom` is enabled for fetching incoming mail.

Refer to [](#ch-options) for all available configuration
options for the [services.gitlab](#opt-services.gitlab.enable) module.

## Maintenance {#module-services-gitlab-maintenance}

### Backups {#module-services-gitlab-maintenance-backups}

Backups can be configured with the options in
[services.gitlab.backup](#opt-services.gitlab.backup.keepTime). Use
the [services.gitlab.backup.startAt](#opt-services.gitlab.backup.startAt)
option to configure regular backups.

To run a manual backup, start the `gitlab-backup` service:

```ShellSession
$ systemctl start gitlab-backup.service
```

### Rake tasks {#module-services-gitlab-maintenance-rake}

You can run GitLab's rake tasks with `gitlab-rake`
which will be available on the system when GitLab is enabled. You
will have to run the command as the user that you configured to run
GitLab with.

A list of all available rake tasks can be obtained by running:

```ShellSession
$ sudo -u git -H gitlab-rake -T
```

## Runner {#module-services-gitlab-runner}

GitLab Runner is a CI runner which is an executable which you can host yourself.
A Gitlab pipeline runs operations over a Gitlab Runner. These can include
building an executable, running a test suite, pushing a docker image, etc. The
Gitlab Runner receives jobs from Gitlab which it then dispatches to the
configured executors
([`docker` (`podman`), or `shell` or `kubernetes`](https://docs.gitlab.com/runner/executors)).

The
[services.gitlab-runner.services](https://search.nixos.org/options?query=services.gitlab-runner.services)
documents a number of typical setups to configure multiple runners with
different executors.

The [below example](#ex-gitlab-runner-podman) gives a **more elaborate** example how to
configure a Gitlab Runner with caching and reasonably good security practices.

::: {#ex-gitlab-runner-podman .example}

## Example Gitlab Runner with `podman` and Nix Store Caching

The [VM tested podman-runner](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/continuous-integration/gitlab-runner/runner.nix) (a NixOS Module for reuse) configures a Gitlab Runner with the following
features:

- The executor is `podman` which gives you better additional safety than
  `docker`. That means every job is run in a `podman` container.

- The following container **images** are built with Nix:

  **Container Images for Gitlab Jobs**:
  - `local/alpine`: An image based on Alpine with a Nix installation
    (variable `alpineImage`).
  - `local/ubuntu`: An image based on Ubuntu with a Nix installation
    (variable `ubuntuImage`).
  - `local/nix`: An image based on Nix which only comes with `nix`
    installed (variable `nixImage`).

  **Images for VM Setup**:
  - `local/nix-daemon-image`: An image with a Nix daemon which is
    used to share the `/nix/store` across jobs (variable `nixDaemonImage`).
  - `local/podman-daemon-image`: An image with a `podman` running as a daemon which is
    used to run `podman` inside the above job containers images
    (variable `podmanDaemonImage`).

- Every job container runs in a `podman` container instance based by default on
  `ubuntuImage`. A pipeline job can override this with `image: local/alpine`.
  - Each job container will have the `/nix/store` mounted from a container
    `nix-daemon-container` (see registration flags
    `--docker-volumes-from "nix-daemon-container:ro"`).

    The `nix-daemon-container` is a single container instance of a
    `nixDaemonImage`. This enables caching of `/nix/store` paths across all jobs
    in **all** runners. This makes **the host VM's `/nix/store` independent of the
    Nix store used in the jobs**, which is good.

    ::: {.note}
    **Security:** If you don't want this you need multiple `nixDaemonImage`
    containers for each registered runner (`gitlab-runner.services.<name>`).
    :::

  - Each job container will have the `/run/podman/podman.sock` socket mounted from the
    `podman-daemon-container`.

    The `podman-daemon-container` is a single container of a `podmanDaemonImage` which runs
    `podman` as a daemon. Job containers can use this daemon to spawn nested containers as well (podman-in-podman). **Keep in mind that `bind` mounts are local to the `podman-daemon-container`** and can be be worked around with a `podman volume create <vol>` and manual copy-to/copy-from this volume `<vol>`.

    If you only need to build containers you don't need this feature (`podman-daemon-container`), see below point.

    Container configuration files (`auxRootFiles`) are copied to all containers to
    ensure `podman` works inside the job containers.

  - The job containers do **not** mount the `podman` socket from the host (NixOS
    VM) mounted for security reasons.

    ::: {.note}
    Building container images with `buildah` (stripped
    `podman` for building images) inside a job which runs `alpineImage`
    is still possible.
    :::

:::
