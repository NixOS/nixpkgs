# shellcheck shell=bash
@name@ () {
  addToSearchPath LHAPDF_DATA_PATH "@out@"
}

postHooks+=(@name@)
