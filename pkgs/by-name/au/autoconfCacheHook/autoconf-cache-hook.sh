autoconfCacheFiles+=(@cacheFile@/config.cache)

_autoconfMergeCaches() {
  local -a ignoreArray
  concatTo ignoreArray autoconfCacheIgnore
  # use the cache file from the store directly if:
  #  - no extra cache files have been defined by the user
  #  - no cache entries should be ignored
  #  - the cache files was not requested to be writable (see debugging hook)
  if [ ${#autoconfCacheFiles[@]} -eq 1 -a ${#ignoreArray[@]} == 0  -a -n "${autoconfWritableCache-}" ]; then
    autoconfCache=${autoconfCacheFiles[0]}
  # otherwise concatenate all cache files and filter out the ignored entries
  else
    autoconfCache=$(mktemp)
    cat ${autoconfCacheFiles[@]} \
      | grep -v -F -f <(for ignore in "${ignoreArray[@]}"; do echo "$ignore"; done) \
      > "$autoconfCache"
    # make cache readonly to prevent ./configure to change it
    if [ -z "${autoconfWritableCache-}" ]; then
      chmod -w "$autoconfCache"
    fi
  fi
}

# This is duplicated logic from the stdenv's setup.sh
# We need to find the configure script in order to determine if it can accept a cache file
_setConfigureScript() {
  # set to empty if unset
  : "${configureScript=}"

  if [[ -z "$configureScript" && -x ./configure ]]; then
      configureScript=./configure
  fi
}

# The actual hook
_autoconfCacheHook() {
  _setConfigureScript
  # exit early if no configure script exists
  if [ -z "$configureScript" ]; then
    return
  fi
  # skip the hook if the ./configure script does not accept the --cache-file option
  if ! grep -q -E '^[^#].*--cache-file' "$configureScript"; then
    echo "not using autoconf cache, configure script does not accept --cache-file"
    return
  fi
  _autoconfMergeCaches
  configureFlagsArray+=("--cache-file=$autoconfCache")
}

if [ -z "${autoconfCacheDebug-}" ] && [ -z "${dontAutoconfCache-}" ]; then
  preConfigureHooks+=(_autoconfCacheHook)
fi


# ------------------------------------------------------------------------------
# ############################### DEBUGGING ####################################
# ------------------------------------------------------------------------------

# This part declares the hook injected when autoconfCacheDebug is set.
# It is used to generate a new cache file and diff it with the precomputed one for debugging.
# The diff is printed to stdout.

# This creates a new cache file by running ./configure manually on an empty cache file
_autoconfGenerateNewCache() {
  autoconfNewCache=$(mktemp)
  flagsOld=("${configureFlagsArray[@]}")
  configureFlagsArray+=("--cache-file=$autoconfNewCache")
  local -a flagsArray
  concatTo flagsArray configureFlags configureFlagsArray
  $configureScript "${flagsArray[@]}"
  unset flagsArray
  # reset flags
  configureFlagsArray=("${flagsOld[@]}")
}

# Computes a diff between a freshly built cache in the current derivation vs the pre-built
#   cache usually injected via the autoconfCacheHook.
# This implementation is not optimized, but it doesn't matter as it is just for debugging.
_autoconfCachePrintDiff() {
  echo "diffing ./configure resulting cache (precomputed <--> current)"
  keys1=$(sed -n 's/^\([^=]*\)=.*/\1/p' "$autoconfCache" | sort)
  keys2=$(sed -n 's/^\([^=]*\)=.*/\1/p' "$autoconfNewCache" | sort)
  keysOnlyIn1=($(comm -23 <(printf '%s\n' "${keys1[@]}") <(printf '%s\n' "${keys2[@]}")))
  keysOnlyIn2=($(comm -13 <(printf '%s\n' "${keys1[@]}") <(printf '%s\n' "${keys2[@]}")))
  keysBoth=($(comm -12 <(printf '%s\n' "${keys1[@]}") <(printf '%s\n' "${keys2[@]}")))
  # print the keys that are only in the first cache file
  if [ ${#keysOnlyIn1[@]} -gt 0 ]; then
    echo "keys only set after ./configure without cache"
    for key in "${keysOnlyIn1[@]}"; do
      echo "  $key"
    done
  fi
  # print the keys that are only in the second cache file
  if [ ${#keysOnlyIn2[@]} -gt 0 ]; then
    echo "keys only set after running ./configure with cache"
    for key in "${keysOnlyIn2[@]}"; do
      echo "  $key"
    done
  fi
  # print the keys that are in both cache files
  if [ ${#keysBoth[@]} -gt 0 ]; then
    echo "keys with conflicting values (with vs without cache):"
    for key in "${keysBoth[@]}"; do
      # extract the values of the keys from both cache files
      value1=$(grep "^$key=" "$autoconfCache" | cut -d= -f2- | tr -d "'" || :)
      value2=$(grep "^$key=" "$autoconfNewCache" | cut -d= -f2- | tr -d "'" || :)
      # compare the values of the keys
      if [ "$value1" != "$value2" ]; then
        echo "  $key: $value1 != $value2"
      fi
    done
  fi
}

# the entrypoint of the hook
_autoconfCacheDebugHook() {
  _setConfigureScript
  _autoconfGenerateNewCache  # creates autoconfNewCache file
  autoconfWritableCache=1
  _autoconfCacheHook
}

if [ -n "${autoconfCacheDebug-}" ]; then
# the cache diffing only makes sense if the original cache was disabled
  preConfigureHooks+=(_autoconfCacheDebugHook)
  postConfigureHooks+=(_autoconfCachePrintDiff)
fi
