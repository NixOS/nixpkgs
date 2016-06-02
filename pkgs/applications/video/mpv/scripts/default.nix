{ lib, mpv }:
with lib;

# Function that creates an mpv with scripts enabled.
# A script is a derivation that evaluates to derivation
# which is a lua file with a name ending on .lua
# (otherwise it is ignored by mpv (which is a bug TODO))
# Additionally, a script can specify that it needs options
# of the mpv package enabled by declaring them in
# passthru.features, e.g.
# passthru.features = { youtubeSupport = true; };
scripts:

  assert isList scripts;
  assert all (s: s.passthru ? features
                 && all isBool (attrValues s.passthru.features)
             ) scripts;

  let features = foldAttrs
                   (a: b: a||b)
                   false
                   (map (s: s.passthru.features) scripts);

  in mpv.override (
       { scripts = scripts; }
       // features
     )


