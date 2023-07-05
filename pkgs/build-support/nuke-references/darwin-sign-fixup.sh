# Fixup hook for nukeReferences, not stdenv

source @signingUtils@

fixupHooks+=(signIfRequired)
