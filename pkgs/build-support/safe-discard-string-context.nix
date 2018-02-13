# | Discard the context of a string while ensuring that expected path
# validity invariants hold.
#
# This relies on import-from-derivation, but it is only useful in
# contexts where the string is going to be used in an
# import-from-derivation anyway.
#
# safeDiscardStringContext : String → String
{ writeText }: s:
  builtins.seq
    (import (writeText
               "discard.nix"
               "${builtins.substring 0 0 s}null\n"))
    (builtins.unsafeDiscardStringContext s)
