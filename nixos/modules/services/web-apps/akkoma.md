# Akkoma {#module-services-akkoma}

[Akkoma](https://akkoma.dev/) is a lightweight ActivityPub microblogging server forked from Pleroma.

## Service configuration {#modules-services-akkoma-service-configuration}

The Elixir configuration file required by Akkoma is generated automatically from
[{option}`services.akkoma.config`](options.html#opt-services.akkoma.config). Secrets must be
included from external files outside of the Nix store by setting the configuration option to
an attribute set containing the attribute {option}`_secret` – a string pointing to the file
containing the actual value of the option.

For the mandatory configuration settings these secrets will be generated automatically if the
referenced file does not exist during startup, unless disabled through
[{option}`services.akkoma.initSecrets`](options.html#opt-services.akkoma.initSecrets).

The following configuration binds Akkoma to the Unix socket `/run/akkoma/socket`, expecting to
be run behind a HTTP proxy on `fediverse.example.com`.


```nix
services.akkoma.enable = true;
services.akkoma.config = {
  ":pleroma" = {
    ":instance" = {
      name = "My Akkoma instance";
      description = "More detailed description";
      email = "admin@example.com";
      registration_open = false;
    };

    "Pleroma.Web.Endpoint" = {
      url.host = "fediverse.example.com";
    };
  };
};
```

Please refer to the [configuration cheat sheet](https://docs.akkoma.dev/stable/configuration/cheatsheet/)
for additional configuration options.

## User management {#modules-services-akkoma-user-management}

After the Akkoma service is running, the administration utility can be used to
[manage users](https://docs.akkoma.dev/stable/administration/CLI_tasks/user/). In particular an
administrative user can be created with

```ShellSession
$ pleroma_ctl user new <nickname> <email> --admin --moderator --password <password>
```

## Proxy configuration {#modules-services-akkoma-proxy-configuration}

Although it is possible to expose Akkoma directly, it is common practice to operate it behind an
HTTP reverse proxy such as nginx.

```nix
services.akkoma.nginx = {
  enableACME = true;
  forceSSL = true;
};

services.nginx = {
  enable = true;

  clientMaxBodySize = "16m";
  recommendedTlsSettings = true;
  recommendedOptimisation = true;
  recommendedGzipSettings = true;
};
```

Please refer to [](#module-security-acme) for details on how to provision an SSL/TLS certificate.

### Media proxy {#modules-services-akkoma-media-proxy}

Without the media proxy function, Akkoma does not store any remote media like pictures or video
locally, and clients have to fetch them directly from the source server.

```nix
# Enable nginx slice module distributed with Tengine
services.nginx.package = pkgs.tengine;

# Enable media proxy
services.akkoma.config.":pleroma".":media_proxy" = {
  enabled = true;
  proxy_opts.redirect_on_failure = true;
};

# Adjust the persistent cache size as needed:
#  Assuming an average object size of 128 KiB, around 1 MiB
#  of memory is required for the key zone per GiB of cache.
# Ensure that the cache directory exists and is writable by nginx.
services.nginx.commonHttpConfig = ''
  proxy_cache_path /var/cache/nginx/cache/akkoma-media-cache
    levels= keys_zone=akkoma_media_cache:16m max_size=16g
    inactive=1y use_temp_path=off;
'';

services.akkoma.nginx = {
  locations."/proxy" = {
    proxyPass = "http://unix:/run/akkoma/socket";

    extraConfig = ''
      proxy_cache akkoma_media_cache;

      # Cache objects in slices of 1 MiB
      slice 1m;
      proxy_cache_key $host$uri$is_args$args$slice_range;
      proxy_set_header Range $slice_range;

      # Decouple proxy and upstream responses
      proxy_buffering on;
      proxy_cache_lock on;
      proxy_ignore_client_abort on;

      # Default cache times for various responses
      proxy_cache_valid 200 1y;
      proxy_cache_valid 206 301 304 1h;

      # Allow serving of stale items
      proxy_cache_use_stale error timeout invalid_header updating;
    '';
  };
};
```

#### Prefetch remote media {#modules-services-akkoma-prefetch-remote-media}

The following example enables the `MediaProxyWarmingPolicy` MRF policy which automatically
fetches all media associated with a post through the media proxy, as soon as the post is
received by the instance.

```nix
services.akkoma.config.":pleroma".":mrf".policies =
  map (pkgs.formats.elixirConf { }).lib.mkRaw [
    "Pleroma.Web.ActivityPub.MRF.MediaProxyWarmingPolicy"
];
```

#### Media previews {#modules-services-akkoma-media-previews}

Akkoma can generate previews for media.

```nix
services.akkoma.config.":pleroma".":media_preview_proxy" = {
  enabled = true;
  thumbnail_max_width = 1920;
  thumbnail_max_height = 1080;
};
```

## Frontend management {#modules-services-akkoma-frontend-management}

Akkoma will be deployed with the `pleroma-fe` and `admin-fe` frontends by default. These can be
modified by setting
[{option}`services.akkoma.frontends`](options.html#opt-services.akkoma.frontends).

The following example overrides the primary frontend’s default configuration using a custom
derivation.

```nix
services.akkoma.frontends.primary.package = pkgs.runCommand "pleroma-fe" {
  config = builtins.toJSON {
    expertLevel = 1;
    collapseMessageWithSubject = false;
    stopGifs = false;
    replyVisibility = "following";
    webPushHideIfCW = true;
    hideScopeNotice = true;
    renderMisskeyMarkdown = false;
    hideSiteFavicon = true;
    postContentType = "text/markdown";
    showNavShortcuts = false;
  };
  nativeBuildInputs = with pkgs; [ jq xorg.lndir ];
  passAsFile = [ "config" ];
} ''
  mkdir $out
  lndir ${pkgs.akkoma-frontends.pleroma-fe} $out

  rm $out/static/config.json
  jq -s add ${pkgs.akkoma-frontends.pleroma-fe}/static/config.json ${config} \
    >$out/static/config.json
'';
```

## Federation policies {#modules-services-akkoma-federation-policies}

Akkoma comes with a number of modules to police federation with other ActivityPub instances.
The most valuable for typical users is the
[`:mrf_simple`](https://docs.akkoma.dev/stable/configuration/cheatsheet/#mrf_simple) module
which allows limiting federation based on instance hostnames.

This configuration snippet provides an example on how these can be used. Choosing an adequate
federation policy is not trivial and entails finding a balance between connectivity to the rest
of the fediverse and providing a pleasant experience to the users of an instance.


```nix
services.akkoma.config.":pleroma" = with (pkgs.formats.elixirConf { }).lib; {
  ":mrf".policies = map mkRaw [
    "Pleroma.Web.ActivityPub.MRF.SimplePolicy"
  ];

  ":mrf_simple" = {
    # Tag all media as sensitive
    media_nsfw = mkMap {
      "nsfw.weird.kinky" = "Untagged NSFW content";
    };

    # Reject all activities except deletes
    reject = mkMap {
      "kiwifarms.cc" = "Persistent harassment of users, no moderation";
    };

    # Force posts to be visible by followers only
    followers_only = mkMap {
      "beta.birdsite.live" = "Avoid polluting timelines with Twitter posts";
    };
  };
};
```

## Upload filters {#modules-services-akkoma-upload-filters}

This example strips GPS and location metadata from uploads, deduplicates them and anonymises the
the file name.

```nix
services.akkoma.config.":pleroma"."Pleroma.Upload".filters =
  map (pkgs.formats.elixirConf { }).lib.mkRaw [
    "Pleroma.Upload.Filter.Exiftool"
    "Pleroma.Upload.Filter.Dedupe"
    "Pleroma.Upload.Filter.AnonymizeFilename"
  ];
```

## Migration from Pleroma {#modules-services-akkoma-migration-pleroma}

Pleroma instances can be migrated to Akkoma either by copying the database and upload data or by
pointing Akkoma to the existing data. The necessary database migrations are run automatically
during startup of the service.

The configuration has to be copy‐edited manually.

Depending on the size of the database, the initial migration may take a long time and exceed the
startup timeout of the system manager. To work around this issue one may adjust the startup timeout
{option}`systemd.services.akkoma.serviceConfig.TimeoutStartSec` or simply run the migrations
manually:

```ShellSession
pleroma_ctl migrate
```

### Copying data {#modules-services-akkoma-migration-pleroma-copy}

Copying the Pleroma data instead of re‐using it in place may permit easier reversion to Pleroma,
but allows the two data sets to diverge.

First disable Pleroma and then copy its database and upload data:

```ShellSession
# Create a copy of the database
nix-shell -p postgresql --run 'createdb -T pleroma akkoma'

# Copy upload data
mkdir /var/lib/akkoma
cp -R --reflink=auto /var/lib/pleroma/uploads /var/lib/akkoma/
```

After the data has been copied, enable the Akkoma service and verify that the migration has been
successful. If no longer required, the original data may then be deleted:

```ShellSession
# Delete original database
nix-shell -p postgresql --run 'dropdb pleroma'

# Delete original Pleroma state
rm -r /var/lib/pleroma
```

### Re‐using data {#modules-services-akkoma-migration-pleroma-reuse}

To re‐use the Pleroma data in place, disable Pleroma and enable Akkoma, pointing it to the
Pleroma database and upload directory.

```nix
# Adjust these settings according to the database name and upload directory path used by Pleroma
services.akkoma.config.":pleroma"."Pleroma.Repo".database = "pleroma";
services.akkoma.config.":pleroma".":instance".upload_dir = "/var/lib/pleroma/uploads";
```

Please keep in mind that after the Akkoma service has been started, any migrations applied by
Akkoma have to be rolled back before the database can be used again with Pleroma. This can be
achieved through `pleroma_ctl ecto.rollback`. Refer to the
[Ecto SQL documentation](https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Rollback.html) for
details.

## Advanced deployment options {#modules-services-akkoma-advanced-deployment}

### Confinement {#modules-services-akkoma-confinement}

The Akkoma systemd service may be confined to a chroot with

```nix
services.systemd.akkoma.confinement.enable = true;
```

Confinement of services is not generally supported in NixOS and therefore disabled by default.
Depending on the Akkoma configuration, the default confinement settings may be insufficient and
lead to subtle errors at run time, requiring adjustment:

Use
[{option}`services.systemd.akkoma.confinement.packages`](options.html#opt-systemd.services._name_.confinement.packages)
to make packages available in the chroot.

{option}`services.systemd.akkoma.serviceConfig.BindPaths` and
{option}`services.systemd.akkoma.serviceConfig.BindReadOnlyPaths` permit access to outside paths
through bind mounts. Refer to
[{manpage}`systemd.exec(5)`](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#BindPaths=)
for details.

### Distributed deployment {#modules-services-akkoma-distributed-deployment}

Being an Elixir application, Akkoma can be deployed in a distributed fashion.

This requires setting
[{option}`services.akkoma.dist.address`](options.html#opt-services.akkoma.dist.address) and
[{option}`services.akkoma.dist.cookie`](options.html#opt-services.akkoma.dist.cookie). The
specifics depend strongly on the deployment environment. For more information please check the
relevant [Erlang documentation](https://www.erlang.org/doc/reference_manual/distributed.html).
