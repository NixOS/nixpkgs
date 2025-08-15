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
