# sed scripts

#http://sourceforge.net/projects/webdruid/files/webdruid/0.6.0-alpha5/webdruid-0.6.0-alpha5.tar.gz/download
#http://downloads.sourceforge.net/webdruid/files/webdruid/0.6.0-alpha5/webdruid-0.6.0-alpha5.tar.gz
skipRedirectSF='s@^http://sourceforge.net/projects/@http://downloads.sourceforge.net/@; s@/download$@@'
extractReleaseSF='s@.*/([^/]+)/[^/]+@\1@'
apacheMirror='s@http://www.apache.org/dist/@mirror://apache/@'
skipRedirectApache='s@/dyn/closer.cgi[?]path=@/dist@'

replaceAllVersionOccurences() {
	echo s/"$version"/\${version}/g
}
dashDelimitedVersion='s/.*-([0-9.]+)-.*/\1/'
