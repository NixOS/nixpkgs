/Asset(.*/ {               # find Asset declaration
s/: Asset(/ = fetchurl {/; # replace leading
  :b;                      # a label
  $!N;                     # if not EOF, include next line
  s/",/";/;                # provide separators between attributes
  /)/!bb;                  # repeat until a closing bracket is located
  s/),/};/;                # provide separators between assets
  p                        # output what we have
}
