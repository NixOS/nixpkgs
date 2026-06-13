{ lib, fetchFromForgejo }:
lib.makeOverridable (args: fetchFromForgejo ({ domain = "codeberg.org"; } // args))
