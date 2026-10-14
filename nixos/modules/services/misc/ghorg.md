# ghorg {#module-services-ghorg}

`services.ghorg` manages scheduled [`ghorg`](https://github.com/gabrie30/ghorg)
`reclone` jobs on NixOS.

It is intended for repository mirroring workflows such as cloning all
repositories from a GitHub organization, a GitLab group, or a self-hosted SCM
instance into a local directory tree.

## Basic usage {#module-services-ghorg-basic-usage}

```nix
{
  services.ghorg = {
    enable = true;
    startAt = "daily";

    jobs.nixpkgs = {
      args = [
        "clone"
        "NixOS"
      ];
      settings = {
        scmType = "github";
        cloneType = "org";
        cloneProtocol = "https";
      };
    };
  };
}
```

## Multiple jobs and credentials {#module-services-ghorg-multiple-jobs-and-credentials}

```nix
{
  services.ghorg = {
    enable = true;
    environmentFile = "/run/secrets/ghorg-common.env";

    jobs = {
      github = {
        args = [
          "clone"
          "my-org"
        ];
        tokenFile = "/run/secrets/github-token";
        settings = {
          scmType = "github";
          cloneType = "org";
          cloneToPath = "/var/lib/ghorg";
          preserveScmHostname = true;
        };
      };

      gitlab = {
        args = [
          "clone"
          "my-group"
        ];
        tokenFile = "/run/secrets/gitlab-token";
        settings = {
          scmType = "gitlab";
          cloneType = "org";
          baseUrl = "https://gitlab.example.com";
          cloneProtocol = "ssh";
        };
      };
    };
  };
}
```
