{
  lib,
  stdenv,
  newScope,
}:

lib.makeScope newScope (self: {

  buildFestivalVoice = self.callPackage ./build-festival-voice.nix {
    inherit lib stdenv;
  };

  # All voices must have the same name as in festival
  # echo '(mapcar (lambda (v) (format t "%s\n" v)) (voice.list))' | festival 2>/dev/null | grep -E '^[a-zA-Z0-9_]+$'

})
