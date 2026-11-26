# Vendored from upstream's `packaging/programs.nix`; keep in sync when updating.
# The programs each of Hydra's programs runs, as data.
#
# Hydra finds every program it runs through its own `HYDRA_PROGRAM_<NAME>`
# variable, never on `PATH` (see `Hydra::Helper::Exec` and the
# `hydra-programs` crate). This says, for each of Hydra's programs, which:
#
# - `foreign`: name to the package providing `bin/<name>`.
# - `local`: Hydra's own programs, by name. Where they are depends on who is
#   asking -- a wrapper package, a NixOS unit, the source tree -- so `envFor`
#   is told.
# - `path`: what a foreign program needs on `PATH` itself, which Hydra can't
#   tell it where to find.
# - `env`: other variables, fixed.
# - `runsPlugins`: whether plugins from outside Hydra run here, so that the
#   deployment's plugin path, `HYDRA_PLUGIN_PATH`, belongs here too.
#
# It is used by the wrappers, the NixOS units, and the test suite, so that
# they agree.
{
  lib,
  stdenv,

  nix,
  nix-eval-jobs,

  coreutils,
  findutils,
  gnused,

  bzip2,
  gnutar,
  gzip,
  pixz,
  unzip,
  xz,
  zstd,
  rpm,
  dpkg,
  cdrkit,

  git,
  openssh,
  top-git,
  mercurial,
  subversion,
  darcs,
  breezy,
}:

let
  programVar = name: "HYDRA_PROGRAM_" + lib.toUpper (lib.replaceStrings [ "-" ] [ "_" ] name);

  nixTools = {
    inherit nix;
    nix-store = nix;
  };

  # For the web app's listings of build products, its log and closure
  # downloads, and the log compression and backups the plugins do.
  archiveTools = {
    inherit
      bzip2
      gzip
      pixz
      unzip
      xz
      zstd
      ;
    find = findutils;
    ls = coreutils;
    tail = coreutils;
    tar = gnutar;
    xargs = findutils;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit rpm;
    dpkg-deb = dpkg;
    isoinfo = cdrkit;
  };

  # For the input plugins.
  vcsTools = {
    inherit darcs git;
    bzr = breezy;
    hg = mercurial;
    nix-prefetch-url = nix;
    rm = coreutils;
    sed = gnused;
    svn = subversion;
    tg = top-git;
  };

  # The version control tools exec `ssh` themselves; those that can be told
  # where it is are.
  sshEnv = {
    GIT_SSH = lib.getExe' openssh "ssh";
    SVN_SSH = lib.getExe' openssh "ssh";
  };

  # Plugins may run anything Hydra knows of.
  plugins = {
    foreign = nixTools // archiveTools // vcsTools;
    env = sshEnv;
  };

  # `git` and `hg` for `/api/scmdiff`, and for the commit listings the input
  # plugins' `getCommits` give. The web app loads the plugins, but otherwise
  # only asks the input plugins for `supportedInputTypes`, which must not run
  # anything.
  webApp = {
    foreign = nixTools // archiveTools // { inherit (vcsTools) git hg; };
    env = sshEnv;
  };

  prefetchTools = {
    inherit (nixTools) nix-store;
    nix-hash = nix;
    mkdir = coreutils;
    mktemp = coreutils;
    rm = coreutils;
  };
in
{
  inherit programVar;

  # The variables an entry calls for, given where Hydra's own programs are:
  # `localPath name` is the path of the one called `name`.
  envFor =
    {
      localPath ? name: throw "packaging/programs.nix: nowhere given for Hydra's own `${name}`",
    }:
    entry:
    lib.mapAttrs' (name: pkg: lib.nameValuePair (programVar name) (lib.getExe' pkg name)) (
      entry.foreign or { }
    )
    // lib.listToAttrs (
      map (name: lib.nameValuePair (programVar name) (localPath name)) (entry.local or [ ])
    )
    // entry.env or { };

  programs = {
    # Perl, which the wrappers wrap.
    hydra-backfill-ids = webApp;
    hydra-create-user = webApp;
    hydra-init = webApp;
    hydra-s3-backup-collect-garbage = webApp;
    hydra-send-stats = webApp;
    hydra-server = webApp;
    hydra-update-gc-roots = webApp;

    hydra-notify = plugins // {
      runsPlugins = true;
    };
    # Fetching inputs also runs the `nix-prefetch-*` scripts.
    hydra-fetch-input = plugins // {
      local = [
        "nix-prefetch-bzr"
        "nix-prefetch-git"
        "nix-prefetch-hg"
      ];
    };
    hydra-prepare-declarative-jobset = plugins;

    nix-prefetch-git.foreign = prefetchTools // {
      inherit (vcsTools) git sed tg;
      find = findutils;
      tr = coreutils;
      xargs = findutils;
    };
    nix-prefetch-hg.foreign = prefetchTools // {
      inherit (vcsTools) hg;
    };
    nix-prefetch-bzr.foreign = prefetchTools // {
      inherit (vcsTools) bzr sed;
    };

    # Rust, which the NixOS units configure directly.
    hydra-evaluator = {
      local = [
        "hydra-fetch-input"
        "hydra-prepare-declarative-jobset"
      ];
      foreign = nixTools // {
        inherit nix-eval-jobs;
      };
      # Nix's git fetcher execs `git` from `PATH`, which needs `ssh` for
      # ssh:// remotes.
      path = [
        git
        openssh
      ];
      runsPlugins = true;
    };
    hydra-queue-runner.foreign = { inherit (nixTools) nix; };
    hydra-builder.foreign = { inherit (nixTools) nix; };
    hydra-ad-hoc = { };
    hydra-ws = { };
  };
}
