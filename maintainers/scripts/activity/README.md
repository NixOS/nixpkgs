# NixOS maintainer activities

In order to maintain `maintainer-list.nix` itself we need a
standardized way to interact with inactive maintainers.

`./activity.bb` is a program, supporting various related tasks.

## Setup

### Access token

- Create a personal access token https://github.com/settings/tokens with capabilities
  - `public_repo`
  - `read:org`
- Save to `~/.config/nixpkgs/maintainer-activity-access-token` or as a [regular nix access token](https://nix.dev/manual/nix/2.18/command-ref/conf-file#conf-access-tokens)

### Environment

```sh
nix-shell -p babashka curl jq
```

## List github user names from `maintainer-list.nix`

```sh
./activity.bb maintainer names
```

## Extract data from github

```sh
./activity.bb gh latest-issue-comment-for <user> | jq
./activity.bb gh latest-contributions-for <user> | jq
./activity.bb gh search-for <user> | jq
```

## Find more data to extract from github

```sh
./activity.bb gh explorer
```

## Change `./activity.bb`

```sh
bb nrepl-server
```

Instructions at start of file in `./activity.bb`.
