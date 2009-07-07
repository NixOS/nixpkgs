source $stdenv/setup

set -x

header "getting revision $selector";

done=;
for source in $dbs; do
	if mtn pull --debug --db "$cacheDB" "$source" "${branch}"; then
		revision="$(mtn --db "$cacheDB" au toposort $(mtn --db "$cacheDB" au select "$selector") | tail -1)";
		if [ -n "$revision" ]; then
			if mtn --db "$cacheDB" au get_revision "$revision"; then
				echo "found revision $revision"
				done=1;
			else
				echo "revision $revision does not exist";
			fi
		else
			echo "selector $selector does not match any revision";
		fi
	else
		echo "pulling branch $branch wasn't succesfull";
	fi;
	if test -n "$done"; then
		break;
	fi;
done;

stopNest;

header "checking out the revision $revision";

if test -n "$done"; then
	mtn checkout --db "$cacheDB" -r "$revision" "$out" -b "${branch}"
else
	echo "Needed revision still not found. Exiting";
	exit 1;
fi;

stopNest

