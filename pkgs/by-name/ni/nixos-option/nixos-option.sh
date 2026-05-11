#!/bin/bash
# shellcheck shell=bash
set -eou pipefail

recursive=false
no_flake=false
positional_args=()
nix_args=(--arg nixos "import <nixpkgs/nixos> { }")
flake=""


discover_git() {
  if [[ $# -ne 1 ]]; then
    echo "$0 directory"
    return 1
  fi
  local previous=
  local current=$1

  while [[ -d "$current" && "$current" != "$previous" ]]; do
    # .git can be a file for worktrees otherwise it's a directory
    if [[ -d "$current/.git" ]]; then
      echo "$current"
      return
    elif [[ -f "$current/.git" ]]; then
      # resolve worktree
      dotgit=$(<"$current/.git")
      if [[ ${dotgit[0]} =~ gitdir:\ (.*) ]]; then
        echo "${BASH_REMATCH[1]}"
        return
      fi
    else
      previous=$current
      current=$(dirname "$current")
    fi
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help)
      exec man -M @nixosOptionManpage@ 8 nixos-option
      ;;

    -r|--recursive)
      recursive=true
      shift
      ;;

    -I)
      nix_args+=("$1" "$2")
      # Not breaking existing usages of it
      no_flake=true
      shift 2
      ;;

    -F|--flake)
      flake=$2
      shift 2
      ;;

    --no-flake)
      no_flake=true
      shift
      ;;

    --show-trace)
      nix_args+=("$1")
      shift
      ;;

    -*)
      echo >&2 "Unsupported option $1"
      exit 1
      ;;

    *)
      positional_args+=("$1")
      shift
      ;;
  esac
done

# Detection order, from high to low:
# `--flake`
# $NIXOS_CONFIG
# nixos-config=<path> in NIX_PATH (normally /etc/nixos/configuration.nix)
# `-I` (implies `--no-flake`)
# `--no-flake`
# /etc/nixos/flake.nix (if exists)

if [[ -n "${NIXOS_CONFIG:-}" ]] || nix-instantiate --find-file nixos-config >/dev/null 2>&1; then
  no_flake=true
fi

if [[ -z "$flake" ]] && [[ -e /etc/nixos/flake.nix ]] && [[ "$no_flake" == "false" ]]; then
  flake="$(dirname "$(realpath /etc/nixos/flake.nix)")"
fi

if [[ -n "$flake" ]]; then
  if [[ $flake =~ ^(.*)\#([^\#\"]*)$ ]]; then
    flake="${BASH_REMATCH[1]}"
    flakeAttr="${BASH_REMATCH[2]}"
  fi
  # Unlike nix cli, builtins.getFlake infer path:// when a path is given
  # See https://github.com/NixOS/nix/issues/5836
  if [[ -d "$flake" ]]; then
      repo=$(discover_git "$(realpath "$flake")")
    if [[ -n "$repo" ]]; then
      flake="git+file://$repo"
    fi
  fi
  if [[ -z "${flakeAttr:-}" ]]; then
    hostname=$(< /proc/sys/kernel/hostname)
    if [[ -z "${hostname:-}" ]]; then
      hostname=default
    fi
    flakeAttr="nixosConfigurations.\"$hostname\""
  else
    flakeAttr="nixosConfigurations.\"$flakeAttr\""
  fi
  nix_args+=(--arg nixos "(builtins.getFlake \"$flake\").$flakeAttr")
fi

case ${#positional_args[@]} in
  0) path= ;;
  # Remove trailing dot if exists, match the behavior of
  # old nixos-option and make shell completions happy
  1) path="${positional_args[0]%.}" ;;
  *) echo >&2 "Only one option path can be provided"; exit 1 ;;
esac

nix-instantiate "${nix_args[@]}" --eval --json \
    --argstr path "$path" \
    --arg recursive "$recursive" \
    @nixosOptionNix@ \
| jq -r
