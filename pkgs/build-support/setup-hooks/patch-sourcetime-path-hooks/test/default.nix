{ callPackage }:
{
  test-bash = callPackage
    (
      { lib
      , runCommandLocal
      , bash
      , ksh
      , patchSourcetimePathBash
      , shellcheck
      , zsh
      }:
      runCommandLocal "patch-sourcetime-path-bash-test"
        {
          nativeBuildInputs = [
            bash
            ksh
            patchSourcetimePathBash
            shellcheck
            zsh
          ];
        } ''
        set -eu -o pipefail
        echo "Running shellcheck against ${./test-sourcing-bash}"
        shellcheck -s bash --exclude SC1090 ${./test-sourcing-bash}
        touch blank.bash
        cp blank.bash blank_patched.bash
        echo "Generating blank_patched.bash from blank.bash"
        patchSourcetimePathBash blank_patched.bash "$PWD/delta:$PWD/foxtrot"
        echo "Running shellcheck against blank_patched.bash"
        shellcheck -s bash blank_patched.bash
        echo "Testing in Bash if blank.bash and blank_patched.bash modifies PATH the same way"
        bash ${./test-sourcing-bash} blank.bash blank_patched.bash
        echo "Testing in Ksh if blank.bash and blank_patched.bash modifies PATH the same way"
        ksh ${./test-sourcing-bash} "$PWD/blank.bash" "$PWD/blank_patched.bash"
        echo "Testing in Zsh if blank.bash and blank_patched.bash modifies PATH the same way"
        zsh ${./test-sourcing-bash} ./blank.bash ./blank_patched.bash
        echo "Running shellcheck against sample_source.bash"
        shellcheck -s bash ${./sample_source.bash}
        cp ${./sample_source.bash} sample_source_patched.bash
        chmod u+w sample_source_patched.bash
        echo "Generating sample_source_patched.bash from ./sample_source.bash"
        patchSourcetimePathBash sample_source_patched.bash "$PWD/delta:$PWD/foxtrot"
        echo "Running shellcheck against sample_source_patched.bash"
        shellcheck -s bash sample_source_patched.bash
        echo "Testing in Bash if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        bash ${./test-sourcing-bash} ${./sample_source.bash} sample_source_patched.bash
        echo "Testing in Ksh if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        ksh ${./test-sourcing-bash} ${./sample_source.bash} "$PWD/sample_source_patched.bash"
        echo "Testing in Zsh if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        zsh ${./test-sourcing-bash} ${./sample_source.bash} ./sample_source_patched.bash
        echo "Patching sample_source_patched.bash the second time"
        patchSourcetimePathBash blank_patched.bash "$PWD/delta:$PWD/golf"
        echo "Running shellcheck against sample_source_patched.bash"
        shellcheck -s bash sample_source_patched.bash
        echo "Testing in Bash if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        bash ${./test-sourcing-bash} ${./sample_source.bash} sample_source_patched.bash
        echo "Testing in Ksh if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        ksh ${./test-sourcing-bash} ${./sample_source.bash} "$PWD/sample_source_patched.bash"
        echo "Testing in Zsh if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        zsh ${./test-sourcing-bash} ${./sample_source.bash} ./sample_source_patched.bash
        touch "$out"
      ''
    )
    { };
  test-csh = callPackage
    (
      { lib
      , runCommandLocal
      , gnused
      , patchSourcetimePathCsh
      , tcsh
      }:
      runCommandLocal "patch-sourcetime-path-csh-test"
        {
          nativeBuildInputs = [
            patchSourcetimePathCsh
            tcsh
          ];
        } ''
        set -eu -o pipefail
        touch blank.csh
        cp blank.csh blank_patched.csh
        echo "Generating blank_patched.csh from blank.csh"
        patchSourcetimePathCsh blank_patched.csh "$PWD/delta:$PWD/foxtrot"
        echo "Testing in Csh if blank.csh and blank_patched.csh modifies PATH the same way"
        tcsh ${./test-sourcing-csh} blank.csh blank_patched.csh
        substitute ${./sample_source.csh.in} sample_source.csh --replace @sed@ ${gnused}/bin/sed
        chmod u+rw sample_source.csh
        cp sample_source.csh sample_source_patched.csh
        chmod u+w sample_source_patched.csh
        echo "Generating sample_source_patched.csh from sample_source.csh"
        patchSourcetimePathCsh sample_source_patched.csh "$PWD/delta:$PWD/foxtrot"
        echo "Testing in Csh if sample_source.csh and sample_source_patched.csh modifies PATH the same way"
        tcsh ${./test-sourcing-csh} sample_source.csh sample_source_patched.csh
        echo "Patching sample_source_patched.csh the second time"
        patchSourcetimePathCsh sample_source_patched.csh "$PWD/delta:$PWD/golf"
        echo "Testing in Csh if sample_source.csh and sample_source_patched.csh modifies PATH the same way"
        tcsh ${./test-sourcing-csh} sample_source.csh sample_source_patched.csh
        touch "$out"
      ''
    )
    { };
  test-fish = callPackage
    (
      { lib
      , runCommandLocal
      , fish
      , patchSourcetimePathFish
      }:
      runCommandLocal "patch-sourcetime-path-fish-test"
        {
          nativeBuildInputs = [
            fish
            patchSourcetimePathFish
          ];
        } ''
        set -eu -o pipefail
        touch blank.fish
        cp blank.fish blank_patched.fish
        echo "Generating blank_patched.fish from blank.fish"
        patchSourcetimePathFish blank_patched.fish "$PWD/delta:$PWD/foxtrot"
        echo "Testing in Fish if blank.fish and blank_patched.fish modifies PATH the same way"
        HOME_TEMP="$(mktemp -d temporary_home_XXXXXX)"
        HOME="$HOME_TEMP" fish ${./test-sourcing-fish} blank.fish blank_patched.fish
        rm -r "$HOME_TEMP"
        cp ${./sample_source.fish} sample_source_patched.fish
        chmod u+w sample_source_patched.fish
        echo "Generating sample_source_patched.fish from ${./sample_source.fish}"
        patchSourcetimePathFish sample_source_patched.fish "$PWD/delta:$PWD/foxtrot"
        echo "Testing in Fish if sample_source.fish and sample_source_patched.fish modifies PATH the same way"
        HOME_TEMP="$(mktemp -d temporary_home_XXXXXX)"
        HOME="$HOME_TEMP" fish ${./test-sourcing-fish} ${./sample_source.fish} sample_source_patched.fish
        rm -r "$HOME_TEMP"
        echo "Patching sample_source_patched.fish the second time"
        patchSourcetimePathFish sample_source_patched.fish "$PWD/delta:$PWD/golf"
        echo "Testing in Fish if sample_source.fish and sample_source_patched.fish modifies PATH the same way"
        HOME_TEMP="$(mktemp -d temporary_home_XXXXXX)"
        HOME="$HOME_TEMP" fish ${./test-sourcing-fish} ${./sample_source.fish} sample_source_patched.fish
        rm -r "$HOME_TEMP"
        touch "$out"
      ''
    )
    { };
  test-posix = callPackage
    (
      { lib
      , runCommandLocal
      , bash
      , dash
      , gnused
      , ksh
      , patchSourcetimePathPosix
      , shellcheck
      }:
      runCommandLocal "patch-sourcetime-path-posix-test"
        {
          nativeBuildInputs = [
            bash
            dash
            ksh
            patchSourcetimePathPosix
            shellcheck
          ];
        } ''
        set -eu -o pipefail
        echo "Running shellcheck against ${./test-sourcing-posix}"
        shellcheck -s sh --exclude SC1090 ${./test-sourcing-posix}
        shellcheck -s dash --exclude SC1090 ${./test-sourcing-posix}
        touch blank.sh
        cp blank.sh blank_patched.sh
        echo "Generating blank_patched.sh from blank.sh"
        patchSourcetimePathPosix blank_patched.sh "$PWD/delta:$PWD/foxtrot"
        echo "Running shellcheck against blank_patched.sh"
        shellcheck -s sh blank_patched.sh
        shellcheck -s dash blank_patched.sh
        echo "Testing in Bash if blank.sh and blank_patched.sh modifies PATH the same way"
        bash --posix ${./test-sourcing-posix} ./blank.sh ./blank_patched.sh
        echo "Testing in Dash if blank.sh and blank_patched.sh modifies PATH the same way"
        dash ${./test-sourcing-posix} ./blank.sh ./blank_patched.sh
        echo "Testing in Ksh if ./blank.sh and ./blank_patched.sh modifies PATH the same way"
        ksh ${./test-sourcing-posix} "$PWD/blank.sh" "$PWD/blank_patched.sh"
        substitute ${./sample_source.sh.in} sample_source.sh --replace @sed@ ${gnused}/bin/sed
        chmod u+rw sample_source.sh
        echo "Running shellcheck against sample_source.sh"
        shellcheck -s sh sample_source.sh
        shellcheck -s dash sample_source.sh
        cp sample_source.sh sample_source_patched.sh
        chmod u+w sample_source_patched.sh
        echo "Generating sample_source_patched.sh from sample_source.sh"
        patchSourcetimePathPosix sample_source_patched.sh "$PWD/delta:$PWD/foxtrot"
        echo "Running shellcheck against sample_source_patched.sh"
        shellcheck -s sh sample_source_patched.sh
        shellcheck -s dash sample_source_patched.sh
        echo "Testing in Bash if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        bash --posix ${./test-sourcing-posix} "./sample_source.sh" "./sample_source_patched.sh"
        echo "Testing in Dash if sample_source.sh and sample_source_patched.sh modifies PATH the same way"
        dash ${./test-sourcing-posix} "./sample_source.sh" "./sample_source_patched.sh"
        echo "Testing in Ksh if sample_source.sh and sample_source_patched.sh modifies PATH the same way"
        ksh ${./test-sourcing-posix} "$PWD/sample_source.sh" "$PWD/sample_source_patched.sh"
        echo "Patching sample_source_patched.sh the second time"
        patchSourcetimePathPosix sample_source_patched.sh "$PWD/delta:$PWD/golf"
        echo "Running shellcheck against sample_source_patched.sh"
        shellcheck -s sh sample_source_patched.sh
        shellcheck -s dash sample_source_patched.sh
        echo "Testing in Bash if sample_source.bash and sample_source_patched.bash modifies PATH the same way"
        bash --posix ${./test-sourcing-posix} "./sample_source.sh" "./sample_source_patched.sh"
        echo "Testing in Dash if sample_source.sh and sample_source_patched.sh modifies PATH the same way"
        dash ${./test-sourcing-posix} "./sample_source.sh" "./sample_source_patched.sh"
        echo "Testing in Ksh if sample_source.sh and sample_source_patched.sh modifies PATH the same way"
        ksh ${./test-sourcing-posix} "$PWD/sample_source.sh" "$PWD/sample_source_patched.sh"
        touch "$out"
      ''
    )
    { };
}
