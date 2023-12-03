#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=. ./. --pure --run true

#
# This file is the single entry point for all CT (Continuous
# Testing) in nixpkgs.  CT is defined to be those checks which
# should be run upon every set of commits before they are merged.
#
# Neither this file nor anything else in the ./ct directory are
# stable interfaces of nixpkgs.  If you depend on anything other
# than the exit code returned by `./ct/default.nix` you need to be
# prepared to respond to and deal with breakage.
#
# All CT runners (ofborg, gerrit, github actions, etc, etc) should
# be configured to invoke this file, which should in turn perform
# the requested action.  CT actions must be runnable locally,
# i.e. by an ordinary developer using a nixpkgs checkout.  Please do
# not write forge-specific/ofborg-specific CT actions.  If you need
# to pass arguments please use `--arg`; we clear the environment
# with `--pure`.
#

{ ...
}@args:

import ./tasks.nix args


