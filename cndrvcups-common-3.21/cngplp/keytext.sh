#
# Modified by Canon INC. on Jul. 2010
# [Change Log]
# the path and name of input file changed.
#
#!/bin/sh
/usr/bin/intltool-extract --type=gettext/glade src/cngplp.glade> /dev/null

cat >gladestr.h <<EOF
EOF
cat src/cngplp.glade.h >>gladestr.h
rm src/cngplp.glade.h
