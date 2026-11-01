# shellcheck shell=bash
@name@ () {
    export G4@envvar@DATA="@datadir@"
}

postHooks+=(@name@)
