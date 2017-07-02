{ writeScript, bash }:
let

  /* takes a folder and distributes all manpages
   * to their needed file structure (man/man1/…)
   * inside outpath.
   *
   * Example: ${distributeManpages} "./manpages" "$out"
   */
  distributeManpages = writeScript "distribute-manpages.sh" ''
    #!${bash}/bin/bash
    set -e; set -o pipefail
    folder=$(realpath -Le "$1")
    outpath=$(realpath -Le "$2")
    # are there more pages than 0–9?
    echo "distributing manpages from \"$folder\" to \"$outpath/man\""
    pushd "$folder"
    for i in $(seq 0 9); do
      for f in $(find -name "*.$i"); do
        to="$outpath/man/man$i"
        install -D --target-directory "$to" "$f"
      done
    done
    popd
  '';

  tests = {

    distributeManpagesExample = ''
      mkdir in man
      infiles="in/a.1 in/b.1 in/a.2 in/c.3 in/x.y"
      outfiles="man/man1/a.1 man/man1/b.1 man/man2/a.2 man/man3/c.3"
      touch $infiles
      mkdir $out
      ${distributeManpages} in $out
      (for f in $outfiles; do
         [[ -a "$out/$f" ]]
      done) || (echo -e "is:\n$(find man/)"; \
                echo -e "should be:\n$(echo "$outfiles" | tr ' ' '\n')")
    '';

    missingFolderError = ''
      ${distributeManpages} foo . \
        && (echo "should fail without input folder"; exit 1)
      mkdir bar
      ${distributeManpages} bar "" \
        && (echo "should fail without output folder"; exit 1)
    '';
  };

in {
  inherit distributeManpages;
  __tests = tests;
}
