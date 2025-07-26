#!/bin/sh
nix-instantiate --eval --strict --json "$(dirname "$0")"/jdk-dashboard.nix

