# Run a builder, flip exit code, save log and fix outputs
#
# Sub-goals:
# - Delegate to another original builder passed via args
# - Save the build log to output for further checks
# - Make the derivation succeed if the original builder fails
# - Make the derivation fail if the original builder returns exit code 0
#
# Requirements:
# This runs before, without and after stdenv. Do not modify the environment;
# especially not before invoking the original builder. For example, use
# "@" substitutions instead of PATH.
# Do not export any variables.

# Stricter bash
set -eu

# ------------------------
# Run the original builder

echo "testBuildFailure: Expecting non-zero exit from builder and args: ${*@Q}"

("$@" 2>&1) | @coreutils@/bin/tee $TMPDIR/testBuildFailure.log \
  | while IFS= read -r ln; do
    echo "original builder: $ln"
  done

r=${PIPESTATUS[0]}
if [[ $r = 0 ]]; then
  echo "testBuildFailure: The builder did not fail, but a failure was expected!"
  exit 1
fi
echo "testBuildFailure: Original builder produced exit code: $r"

# -----------------------------------------
# Write the build log to the default output
#
# # from stdenv setup.sh
getAllOutputNames() {
    if [ -n "$__structuredAttrs" ]; then
        echo "${!outputs[*]}"
    else
        echo "$outputs"
    fi
}

outs=( $(getAllOutputNames) )
defOut=${outs[0]}
defOutPath=${!defOut}

if [[ ! -d $defOutPath ]]; then
  if [[ -e $defOutPath ]]; then
    @coreutils@/bin/mv $defOutPath $TMPDIR/out-node
    @coreutils@/bin/mkdir $defOutPath
    @coreutils@/bin/mv $TMPDIR/out-node $defOutPath/result
  fi
fi

@coreutils@/bin/mkdir -p $defOutPath
@coreutils@/bin/mv $TMPDIR/testBuildFailure.log $defOutPath/testBuildFailure.log
echo $r >$defOutPath/testBuildFailure.exit

# ------------------------------------------------------
# Put empty directories in place for any missing outputs

for outputName in ${outputs:-out}; do
  outputPath="${!outputName}"
  if [[ ! -e "${outputPath}" ]]; then
    @coreutils@/bin/mkdir "${outputPath}";
  fi
done
