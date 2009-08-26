# sed scripts

#http://sourceforge.net/projects/webdruid/files/webdruid/0.6.0-alpha5/webdruid-0.6.0-alpha5.tar.gz/download
#http://downloads.sourceforge.net/webdruid/files/webdruid/0.6.0-alpha5/webdruid-0.6.0-alpha5.tar.gz
skipRedirectSF='s@^http://sourceforge.net/projects/@http://downloads.sourceforge.net/@; s@/download$@@'
extractReleaseSF='s@.*/([^/]+)/[^/]+@\1@'
