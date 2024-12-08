{ lib
, runCommand
, root
, bash
, fish
, tcsh
, zsh
}: runCommand "test-thisroot"
{
  meta = with lib; {
    description = "Test for root thisroot.* sourcing";
    maintainers = unique ((with maintainers; [ ShamrockLee ]) ++ root.meta.maintainers);
  };
}
  ''
    set -eu -o pipefail
    declare -a shellNameArray shellOutpathArray sourcefileNameArray sourceCommandArray
    shellNameArray=( bash zsh tcsh fish )
    shellOutpathArray=( "${bash}" "${zsh}" "${tcsh}" "${fish}")
    sourcefileNameArray=( thisroot.sh thisroot.sh thisroot.csh thisroot.fish )
    sourceCommandArray=( "source" "source" "source" "source" )
    debugFlagstrArray=( "-e" "-e" "-e" "" )
    nShellToTest="''${#shellNameArray[@]}"
    if [[ "''${#shellOutpathArray[@]}" -ne "$nShellToTest" ]] \
      || [[ "''${#sourcefileNameArray[@]}" -ne "$nShellToTest" ]] \
      || [[ "''${#sourceCommandArray[@]}" -ne "$nShellToTest" ]] \
      || [[ "''${#debugFlagstrArray[@]}" -ne "$nShellToTest" ]]
    then
      echo "error: Lengths of test parameter arrays doesn't match." >&2
      exit 1
    fi
    typePExpect="${root}/bin/root"
    for ((i=0; i<$nShellToTest; ++i)); do
      tryCommand="''${sourceCommandArray[$i]} \"${root}/bin/''${sourcefileNameArray[$i]}\""
      echo "Testing ''${shellNameArray[$i]} $tryCommand"
      # Home directory for Fish
      HOME_TEMP="$(mktemp -d temporary_home_XXXXXX)"
      binPATHGot="$(PATH="''${shellOutpathArray[$i]}/bin" HOME=$HOME_TEMP "''${shellNameArray[$i]}" ''${debugFlagstrArray[$i]} -c "$tryCommand && echo \"\$PATH\"")"
      rm -r "$HOME_TEMP"
      typePGot="$(PATH="$binPATHGot" type -p root)"
      if [[ "$typePGot" != "$typePExpect" ]]; then
        echo "error: Got PATH \"$binPATHGot\", in which the root executable path is \"$typePGot\". Expect root executable path \"$typePExpect\"." >&2
        exit 1
      fi
    done
    echo "test-thisroot pass!"
    touch "$out"
  ''
