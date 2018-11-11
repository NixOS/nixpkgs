# This file contains all Bazel repositories, manually translated to Nix code so
# that we can perform a build without any network access.
#
# When changing this file, it's helpful to run a gvisor build using the
# following command, which generates a "resolved.bzl" file containing all
# dependencies:
#   bazel sync --experimental_repository_cache=$PWD/my_cache --experimental_repository_resolved_file=./resolved.bzl
#

{
# From stdenv
  fetchFromGitHub
, fetchgit
, fetchurl
, fetchzip
, buildGoPackage
, unzip
}:

let

  # Actual Bazel dependencies.
  deps = rec {
    io_bazel_rules_go = fetchzip {
      url       = "https://github.com/bazelbuild/rules_go/releases/download/0.16.2/rules_go-0.16.2.tar.gz";
      sha256    = "05a8ya3qqxziz92f9srcfy7a1nv4a2vahx1mh8mjr0p01b2r4f8c";
      stripRoot = false;
    };

    bazel_gazelle = fetchzip {
      url       = "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.15.0/bazel-gazelle-0.15.0.tar.gz";
      sha256    = "1w99splkwxggjai66aar1lx5rsmcayrvh6v4id4gliww2daqqq1k";
      stripRoot = false;
    };

    com_github_google_subcommands = fetchFromGitHubAndGazelle {
      owner  = "google";
      repo   = "subcommands";
      rev    = "ce3d4cfc062faac7115d44e5befec8b5a08c3faa";
      sha256 = "046hwy73nlrlh7k0ar6zqmb9c1zvclc701a7q6mhbzsisc1cnb1m";
    };

    com_github_cenkalti_backoff = fetchFromGitHubAndGazelle {
      owner  = "cenkalti";
      repo   = "backoff";
      rev    = "66e726b43552c0bab0539b28e640b89fd6862115";
      sha256 = "0ng3dhng23n8anj19fn264l7f59i3916rxzvzmc7fg271nprpshq";
    };

    com_github_syndtr_gocapability = fetchFromGitHubAndGazelle {
      owner  = "syndtr";
      repo   = "gocapability";
      rev    = "d98352740cb2c55f81556b63d4a1ec64c5a319c2";
      sha256 = "04jb3hyxq4h4ak9l0dpgfq5lzzipakrk31fw6902fziz6lp29sxg";
    };

    com_github_opencontainers_runtime-spec = fetchFromGitHubAndGazelle {
      owner  = "opencontainers";
      repo   = "runtime-spec";
      rev    = "b2d941ef6a780da2d9982c1fb28d77ad97f54fc7";
      sha256 = "1swpwva2vzlmna2r02bdxzb54ggpcjis5faaaqx29g1jv1k8k2h7";
    };

    org_golang_x_tools = fetchurl {
      urls   = ["https://codeload.github.com/golang/tools/zip/3e7aa9e59977626dc60433e9aeadf1bb63d28295"];
      sha256 = "0s7c1sfqb6xvhwcs0s1q8byw62fzdn0r0dw561sk6qhiwcs8xp3c";

      recursiveHash = true;
      downloadToTemp = true;

      postFetch = ''
        set -ex
        unpackDir="$TMPDIR/unpacked"
        mkdir "$unpackDir" && cd "$unpackDir"

        ${unzip}/bin/unzip -qq "$downloadedFile"

        cd "$TMPDIR"
        mkdir unpacked-stripped

        shopt -s dotglob
        mv "$unpackDir/tools-3e7aa9e59977626dc60433e9aeadf1bb63d28295"/* unpacked-stripped/
        shopt -u dotglob

        unpackDir="$TMPDIR/unpacked-stripped"

        touch "$unpackDir/WORKSPACE"
        cd "$unpackDir"
        patch -p1 < ${io_bazel_rules_go}/third_party/org_golang_x_tools-gazelle.patch
        patch -p1 < ${io_bazel_rules_go}/third_party/org_golang_x_tools-extras.patch


        cd "$TMPDIR"
        mv "$unpackDir" "$out"
      '';
    };

    org_golang_x_sys = fetchgit {
      url    = "https://github.com/golang/sys";
      rev    = "e4b3c5e9061176387e7cea65e4dc5853801f3fb7";
      sha256 = "0r6nff5dd5ypqaq1d4vjkfdgainj090i3h88j13369jfzwsnvcjv";

      postFetch = ''
        set -ex
        cd "$out"
        touch "$out/WORKSPACE"
        cd "$unpackDir"
        patch -p1 < ${io_bazel_rules_go}/third_party/org_golang_x_sys-gazelle.patch
      '';
    };

    com_github_golang_protobuf = fetchgit {
      url    = "https://github.com/golang/protobuf";
      rev    = "aa810b61a9c79d51363740d207bb46cf8e620ed5";
      sha256 = "1f20bk7y27wwzq56pdajkpkk2bw9krw2yz7h1xqyv9nr9pszsk0x";

      postFetch = ''
        set -ex
        cd "$out"
        touch "$out/WORKSPACE"
        cd "$unpackDir"
        patch -p1 < ${io_bazel_rules_go}/third_party/com_github_golang_protobuf-gazelle.patch
        patch -p1 < ${io_bazel_rules_go}/third_party/com_github_golang_protobuf-extras.patch
      '';
    };

    com_google_protobuf = fetchurl {
      urls   = ["https://codeload.github.com/google/protobuf/zip/48cb18e5c419ddd23d9badcfe4e9df7bde1979b2"];
      sha256 = "1bg40miylzpy2wgbd7l7zjgmk43l12q38fq0zkn0vzy1lsj457sq";

      recursiveHash = true;
      downloadToTemp = true;

      postFetch = ''
        set -ex
        unpackDir="$TMPDIR/unpacked"
        mkdir "$unpackDir" && cd "$unpackDir"

        ${unzip}/bin/unzip -qq "$downloadedFile"

        cd "$TMPDIR"
        mkdir unpacked-stripped

        shopt -s dotglob
        mv "$unpackDir/protobuf-48cb18e5c419ddd23d9badcfe4e9df7bde1979b2"/* unpacked-stripped/
        shopt -u dotglob

        unpackDir="$TMPDIR/unpacked-stripped"

        touch "$unpackDir/WORKSPACE"
        # no patches

        cd "$TMPDIR"
        mv "$unpackDir" "$out"
      '';
    };

    com_github_google_btree = fetchFromGitHubAndGazelle {
      owner  = "google";
      repo   = "btree";
      rev    = "4030bb1f1f0c35b30ca7009e9ebd06849dd45306";
      sha256 = "10lgk3wwvp9li3v6nhl0ibw09fbh8nk10ymg3f6kqsdaparbxhk8";
    };

    com_github_gofrs_flock = fetchFromGitHubAndGazelle {
      owner  = "gofrs";
      repo   = "flock";
      rev    = "886344bea0798d02ff3fae16a922be5f6b26cee0";
      sha256 = "0pa9glnhzmv0pmd25hv5qhkxfqjq14swmrrgr612f67vzg0g4acy";
    };

    com_github_kr_pty = fetchFromGitHubAndGazelle {
      owner  = "kr";
      repo   = "pty";
      rev    = "282ce0e5322c82529687d609ee670fac7c7d917c";
      sha256 = "0g8873xnb5nc00d5d39jnp3k63rblxl501dmyxsxp684whv9spa9";
    };

    com_github_vishvananda_netlink = fetchFromGitHubAndGazelle {
      owner  = "vishvananda";
      repo   = "netlink";
      rev    = "d35d6b58e1cb692b27b94fc403170bf44058ac3e";
      sha256 = "1hhw86m40xfslr2fjn8vmlv11d449n7ipgdiv7ayiclqfmlxvp2b";
    };

    com_github_vishvananda_netns = fetchFromGitHubAndGazelle {
      owner  = "vishvananda";
      repo   = "netns";
      rev    = "be1fbeda19366dea804f00efff2dd73a1642fdcc";
      sha256 = "0kfgg366klig1xyjbd1yzj99yzqw4r5ylpq3ilr6sh0bi1jizpz8";
    };
  };

  # Build gazelle using the same dependencies.
  gazelle = buildGoPackage rec {
    name = "bazel-gazelle-${version}";
    version = "2018-11-10";

    goPackagePath = "github.com/bazelbuild/bazel-gazelle";
    goDeps = ./gazelle-deps.nix;
    subPackages = [ "cmd/gazelle" ];

    src = deps.bazel_gazelle;
  };

  # Wrapper around `fetchFromGitHub` that calls `gazelle` on the fetched
  # repository.
  # TODO(andrew-d): make this work on non-GitHub dependencies
  fetchFromGitHubAndGazelle = args @ { owner, repo, ... }: fetchFromGitHub (args // {
    extraPostFetch = ''
      cd $out
      ${gazelle}/bin/gazelle \
        -go_prefix "github.com/${owner}/${repo}" \
        -repo_root "$PWD"
      touch WORKSPACE
    '' + (if args ? "extraPostFetch" then args.extraPostFetch else "");
  });

in deps
