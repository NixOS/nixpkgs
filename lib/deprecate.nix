# deprecation functions

let
  releases = import ./releases.nix;
  trivial  = import ./trivial.nix;

in
{
    warnRenamed = {
      oldName
    , newName
    , reason
    , removedAt ? releases.next
    }: trivial.warn ''
      "${oldName}" has been renamed to "${newName}".
      It will be removed in ${releases.asString removedAt}.
      Reason: ${reason}
    '';
}
