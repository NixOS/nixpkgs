#!/usr/bin/env bash
set -euo pipefail
if (( $# != 1 )); then
    echo "usage: $0 APPLIED_SOURCE/config/ompi_fortran_check_real16_c_equiv.m4" >&2
    exit 2
fi
testDir=$(mktemp -d)
trap 'rm -rf "$testDir"' EXIT
cp "$1" "$testDir/real16.m4"
cd "$testDir"
cat > configure.ac <<'M4'
AC_INIT([openmpi-quad-branch-control], [1])
AC_PROG_CC
AC_DEFUN([OPAL_VAR_SCOPE_PUSH], [])
AC_DEFUN([OPAL_VAR_SCOPE_POP], [])
AC_DEFUN([OPAL_FLAGS_APPEND_UNIQ], [])
m4_include([real16.m4])
AC_DEFUN([AC_CHECK_TYPES], [ac_cv_type__Quad=$quad_available])
dnl Exercise the real outer macro with controlled type/representation answers.
dnl No claim is made that BUILD's compiler implements Intel's _Quad type.
AC_DEFUN([OMPI_FORTRAN_CHECK_REAL16_EQUIV_TYPE], [
    echo "$1" >> probes
    case "$1" in
      _Quad) fortran_real16_happy=$quad_matches ;;
      *) fortran_real16_happy=no ;;
    esac
])
OMPI_TRY_FORTRAN_BINDINGS=1
OMPI_FORTRAN_NO_BINDINGS=0
OMPI_HAVE_FORTRAN_REAL16=1
OMPI_FORTRAN_REAL16_C_TYPE="long double"
ac_cv_type__Float128=no
ac_cv_type___float128=no
ac_cv_type__Quad=$quad_available
OMPI_FORTRAN_CHECK_REAL16_C_EQUIV
AS_ECHO(["$ompi_real16_matches_c:$OMPI_FORTRAN_REAL16_C_TYPE"]) > result
AC_OUTPUT
M4
autoconf
for match in yes no; do
    rm -f probes
    quad_available=yes quad_matches=$match ./configure > "configure-$match.log" 2>&1
    grep -qx '_Quad' probes
    if [[ $match == yes ]]; then
        grep -qx 'yes:_Quad' result
    else
        grep -qx 'no:long double' result
    fi
    echo "PASS available _Quad representation=$match"
done
rm -f probes
quad_available=no quad_matches=yes ./configure > configure-unavailable.log 2>&1
if grep -qx '_Quad' probes; then
    echo "unavailable _Quad unexpectedly reached representation probe" >&2
    exit 1
fi
grep -qx 'no:long double' result
echo "PASS unavailable _Quad is not probed"
