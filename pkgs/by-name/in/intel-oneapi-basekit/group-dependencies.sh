#!/usr/bin/env nix-shell
#!nix-shell -i bash -p ripgrep gawk coreutils

# Pipe the toolkit build log through this script to see
# which components are missing which dependencies.
#
# For example:
# $ nix log /nix/store/k5p88p8qih7aw7fs2yvxgz37sc8dr4mx-intel-oneapi-hpckit-2025.2.0.575.drv | ./group-dependencies.sh
# advisor:
#   - libgdbm_compat.so.4
#   - libgdbm.so.4
#   - libXxf86vm.so.1
#
# vtune:
#   - libgdbm_compat.so.4
#   - libgdbm.so.4
#   - libopencl-clang.so.14

rg "error: auto-patchelf could not satisfy dependency (.+?) wanted by (.+)" -r '$2: $1' | \
  awk '
    BEGIN { FS = ": "; OFS = ": " }

    # Nearly everything requires libz.so.1, so we filter it out for brevity
    $2 == "libz.so.1" { next }

    # Group dependencies by the OneAPI component they are a part of
    # (like mpi, advisor, compiler, ...)
    {
      if (match($1, /\/opt\/intel\/oneapi\/([^\/]+)/, a)) {
        print a[1], $2
      } else {
        print "other", $2
      }
    }
  ' | \
  sort -u | \
  awk '
    BEGIN { FS = ": " }
    $1 != last_group {
      if (NR > 1) { print "" } # Add space between groups
      print $1 ":"
      last_group = $1
    }
    { print "  - " $2 }
  '
