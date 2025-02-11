# check if the package contains all the files needed
for x in faxq faxquit hfaxd faxcron faxqclean faxgetty
do
  test -x "$out/spool/bin/$x"
done
test -d "$out/spool/config"
test -f "$out/spool/etc/setup.cache"
