{ lib }:

# This module contains helpers for the `programs.dconf` NixOS module

rec {
  types = {
    tuple = "_tuple";
  };

  mkTuple = _elements: {
    inherit _elements;

    _type = types.tuple;
  };
}
