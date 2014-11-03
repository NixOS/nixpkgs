findTarballs() {
    local suffix
    test -d "$1/tarballs/" && {
        for suffix in tar.gz tgz tar.bz2 tbz2 tar.xz tar.lzma; do
            ls $1/tarballs/*.$suffix 2> /dev/null
        done | sort
    }
    echo "$1"
}

canonicalizeJarManifest() {
	local input=$1
	# http://docs.oracle.com/javase/7/docs/technotes/guides/jar/jar.html#Notes_on_Manifest_and_Signature_Files
	(head -n 1 $input && tail -n +2 $input | sort | grep -v '^\s*$') > $input-tmp
	mv $input-tmp $input
}

# Post-process a jar file to contain canonical timestamps and metadata ordering
canonicalizeJar() {
	local input=$1
	local outer=$(pwd)
	unzip -qq $input -d $input-tmp
	canonicalizeJarManifest $input-tmp/META-INF/MANIFEST.MF
	# Set all timestamps to Jan 1 1980, which is the earliest date the zip format supports...
	find $input-tmp -exec touch -t 198001010000.00 {} +
	rm $input
	pushd $input-tmp
	zip -q -r -o -X $outer/tmp-out.jar . 2> /dev/null
	popd
	rm -rf $input-tmp
	mv $outer/tmp-out.jar $input
}

propagateImageName() {
    mkdir -p $out/nix-support
    cat "$diskImage"/nix-support/full-name > $out/nix-support/full-name
}
