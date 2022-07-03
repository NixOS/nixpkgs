#!/usr/bin/env nix-shell
#!nix-shell ./generate-shell.nix -i bash
# shellcheck shell=bash

scala-cli generate.scala
