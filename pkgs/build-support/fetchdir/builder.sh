source $stdenv/setup

mkdir $out

# as in fetchurl ignoring the ssl certificate is not a problem
# because we compare with the cryptographic hash anyway.
wget --recursive \
     --no-parent \
     --no-host-directories \
     --cut-dirs=$cut_dirs \
     --convert-links \
     --directory-prefix=$out \
     --no-check-certificate \
     --no-verbose \
     "${url}"

stopNest
