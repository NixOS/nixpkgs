#!/bin/bash
# shellcheck shell=bash
set -eou pipefail

recursive=false
no_flake=false
positional_args=()
nix_args=(--arg nixos "import <nixpkgs/nixos> { }")
flake=""

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

if [[ -z "$flake" ]] && [[ -e /etc/nixos/flake.nix ]] && [[ "$no_flake" == "false" ]]; then
  flake="$(dirname "$(realpath /etc/nixos/flake.nix)")"
fi

if [[ -n "$flake" ]]; then
  echo >&2 "[WARN] Flake support in nixos-option is experimental and has known issues."

  if [[ $flake =~ ^(.*)\#([^\#\"]*)$ ]]; then
    flake="${BASH_REMATCH[1]}"
    flakeAttr="${BASH_REMATCH[2]}"
  fi
  # Unlike nix cli, builtins.getFlake infer path:// when a path is given
  # See https://github.com/NixOS/nix/issues/5836
  # Using `git rev-parse --show-toplevel` since we can't assume the flake dir
  # itself is a git repo, because the flake could be in a sub directory
  if [[ -d "$flake" ]] && git -C "$flake" rev-parse --show-toplevel &>/dev/null; then
    flake="git+file://$(realpath "$flake")"
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
