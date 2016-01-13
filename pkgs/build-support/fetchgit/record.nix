{ fetchgit, record-playback, stdenv }: { recordCommands ? [], ... }@allargs:
with stdenv.lib;
let

  args = filterAttrs (name: v: name != "recordCommands") allargs;

  script = map (cmd: "(cd $out && record-command git ${cmd})") recordCommands;

in overrideDerivation (fetchgit args) (attrs: {

  buildInputs = (attrs.buildInputs or []) ++ [ record-playback ];

  NIX_PREFETCH_GIT_CHECKOUT_HOOK = concatStringsSep "\n" script;

})
