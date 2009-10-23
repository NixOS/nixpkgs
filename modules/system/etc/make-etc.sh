source $stdenv/setup

ensureDir $out/etc

sources_=($sources)
targets_=($targets)
modes_=($modes)

cat <<EOF >> fill-etc.c
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <unistd.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <limits.h>
    #include <sys/wait.h>

    struct stat statBuffer;

    void ensureDir(char* path) {
        int i, j;
        char pathBuffer[PATH_MAX];
        statBuffer.st_mode = 0;
        for (i=0; path[i]; i++) {
            if (path[i]=='/') {
                pathBuffer[i]=0;
                mkdir(pathBuffer ,0755);
		j = i;
            }
            pathBuffer[i]=path[i];
        }
	pathBuffer[j]=0;
        if (stat(pathBuffer, &statBuffer) || ! (statBuffer.st_mode & S_IFDIR)) {
            printf ("Path does not exist or not a directory: %s\n", path);
            exit (EXIT_FAILURE);
        }
    }

    void copyAndChmod(char* path, char* target, mode_t mode) {
        int pid;
        pid = fork();
        if (! pid) {
            execl("${coreutils}/bin/cp", "cp", path, target, NULL);
        } else {
            waitpid (pid, NULL, 0);
        }
        chmod (target, mode);
    }
    
    int main () {
        /* generated code begins */
EOF
cat <<EOF >> kill-etc.c
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <unistd.h>

    int main () {
        /* generated code begins */
EOF

for ((i = 0; i < ${#targets_[@]}; i++)); do
    ensureDir $out/etc/$(dirname ${targets_[$i]})
    if ! test -e $out/etc/${targets_[$i]}; then
        ln -s ${sources_[$i]} $out/etc/${targets_[$i]};
    else
        echo "Duplicate entry ${targets_[$i]} -> ${sources_[$i]}"
        if test "$(readlink $out/etc/${targets_[$i]})" != "${sources_[$i]}"; then
            echo "Mismatched duplicate entry $(readlink $out/etc/${targets_[$i]}) <-> ${sources_[$i]}"
        exit 1
        fi
    fi;
    echo "ensureDir(\"/etc/${targets_[$i]}\");" >> fill-etc.c
    if test "${modes_[$i]}" != symlink; then
        echo "${modes_[$i]}" > $out/etc/${targets_[$i]}.mode

        echo "copyAndChmod(\"$out/etc/${targets_[$i]}\",\"/etc/${targets_[$i]}\",${modes_[$i]});" >> fill-etc.c;
    else
       echo "symlink(\"$out/etc/${targets_[$i]}\",\"/etc/${targets_[$i]}\");" >> fill-etc.c;
    fi

    echo "unlink (\"/etc/${targets_[$i]}\");" >> kill-etc.c
done

echo "symlink(\"$out/bin/kill-etc\",\"/etc/kill-etc\");" >> fill-etc.c
echo "unlink(\"/etc/kill-etc\");" >> kill-etc.c
echo "  return 0; }" >> fill-etc.c
echo "  return 0; }" >> kill-etc.c
ensureDir $out/bin
ensureDir $out/share/etc-scripts/src
gcc -Wall fill-etc.c -o $out/bin/fill-etc
gcc -Wall kill-etc.c -o $out/bin/kill-etc
cp fill-etc.c $out/share/etc-scripts/src
cp kill-etc.c $out/share/etc-scripts/src

