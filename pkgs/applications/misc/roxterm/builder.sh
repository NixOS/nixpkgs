
# Fix up python path so the lockfile library is on it.
# TODO: This probably shouldn't hardcode python2.7.
for path in $pythonPath; do
	echo $path
	PYTHONPATH="${PYTHONPATH}${path}/lib/python2.7/site-packages:"
done
export PYTHONPATH

# Fix up the LD_LIBRARY_PATH so that expat is on it
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ldLibraryPath"

source $stdenv/setup

unpackPhase
cd "$name"

python mscript.py configure --prefix="$out"
python mscript.py build
python mscript.py install

wrapProgram "$out/bin/roxterm" \
	--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
