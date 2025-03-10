# shellcheck shell=bash

# Early return without logging attempting to source this file if we've already sourced it because this
# script is used in a number of places and we don't want to spam the log.
((${sourceGuardSourced:-0} == 1)) && return 0

# sourceGuardArgumentCheck checks the arguments accepted by the sourceGuard family of functions.
sourceGuardArgumentCheck() {
  local -ir numArgsExpected=$1
  shift
  if ((numArgsExpected < 1 || 2 < numArgsExpected)); then
    nixErrorLog "numArgsExpected must be 1 or 2, but got $numArgsExpected"
    exit 1
  fi

  if (($# != numArgsExpected)); then
    nixErrorLog "${FUNCNAME[1]} expected $numArgsExpected arguments, but got $#!"
    if ((numArgsExpected == 1)); then
      nixErrorLog "usage: ${FUNCNAME[1]} guardName"
    elif ((numArgsExpected == 2)); then
      nixErrorLog "usage: ${FUNCNAME[1]} guardName script"
    fi
    exit 1
  fi

  local -r guardName="$1"
  if [[ -z $guardName ]]; then
    nixErrorLog "${FUNCNAME[1]}: guardName argument for script $script must not be empty"
    exit 1
  fi
  ((numArgsExpected == 1)) && return 0

  local -r script="$2"
  if [[ ! -f $script || ! -r $script ]]; then
    nixErrorLog "${FUNCNAME[1]}: guardName $guardName supplied script $script which is not a readable file"
    exit 1
  fi

  return 0
}

# Returns zero if the guard has been sourced, one otherwise.
sourceGuardHasSourced() {
  sourceGuardArgumentCheck 1 "$@"
  local -r guardName="$1"
  local -nr guardNameSourcedRef="${guardName}Sourced"
  return $((1 - ${guardNameSourcedRef:-0}))
}

# sourceGuardPrintCurrent prints the current guard name and script.
sourceGuardPrintCurrent() {
  sourceGuardArgumentCheck 2 "$@"
  local -r guardName="$1"
  local -r script="$2"
  echo -n \
    "guardName=$guardName" \
    "script=$script" \
    "hostOffset=${hostOffset:-0}" \
    "targetOffset=${targetOffset:-0}"
  return 0
}

# sourceGuardPrintSourced prints the sourced guard name and script.
# It is an error to call this function if the script has not been sourced.
sourceGuardPrintSourced() {
  sourceGuardArgumentCheck 1 "$@"
  local -r guardName="$1"
  local -nr guardNameSourcedRef="${guardName}Sourced"

  if ((${guardNameSourcedRef:-0} == 0)); then
    nixErrorLog "guardName $guardName has not been sourced"
    exit 1
  fi

  local -nr guardNameSourcedScriptRef="${!guardNameSourcedRef}Script"
  local -nr guardNameSourcedHostOffsetRef="${!guardNameSourcedRef}HostOffset"
  local -nr guardNameSourcedTargetOffsetRef="${!guardNameSourcedRef}TargetOffset"

  echo -n \
    "guardName=$guardName" \
    "script=${guardNameSourcedScriptRef:?}" \
    "hostOffset=${guardNameSourcedHostOffsetRef:?}" \
    "targetOffset=${guardNameSourcedTargetOffsetRef:?}"

  return 0
}

# sourceGuardSetSourced sets the sourced guard name and script.
# It is an error to call this function if the script has already been sourced.
sourceGuardSetSourced() {
  sourceGuardArgumentCheck 2 "$@"
  local -r guardName="$1"
  local -r script="$2"

  if sourceGuardHasSourced "$guardName"; then
    nixErrorLog "guardName $guardName has already been sourced"
    exit 1
  fi

  declare -gir "${guardName}Sourced"=1
  declare -gr "${guardName}SourcedScript"="$script"
  declare -gir "${guardName}SourcedHostOffset"="${hostOffset:-0}"
  declare -gir "${guardName}SourcedTargetOffset"="${targetOffset:-0}"

  return 0
}

# sourceGuard ensures:
#
# - the script is sourced at most once per build
# - the script must be in a dependency array such that the script is a build-time dependency
# - the script exists and is readable
sourceGuard() {
  sourceGuardArgumentCheck 2 "$@"
  local -r guardName="$1"
  local -r script="$2"

  # Check if we have already sourced the script
  if sourceGuardHasSourced "$guardName"; then
    nixInfoLog "skipping sourcing $(sourceGuardPrintCurrent "$guardName" "$script")" \
      "because we have already sourced $(sourceGuardPrintSourced "$guardName")"
  elif [[ -n ${strictDeps:-} && ${hostOffset:?} -ge 0 ]]; then
    nixInfoLog "skipping sourcing $(sourceGuardPrintCurrent "$guardName" "$script")" \
      "because it is not a build-time dependency"
  else
    sourceGuardSetSourced "$guardName" "$script"
    nixInfoLog "sourcing $(sourceGuardPrintSourced "$guardName")"
    # shellcheck disable=SC1090
    source "$script" || {
      nixErrorLog "failed to source $(sourceGuardPrintSourced "$guardName")"
      exit 1
    }
  fi

  return 0
}

# If we've not already sourced this file, try to source it, and make sourceGuard readonly if we were successfull.
if ! sourceGuardHasSourced "sourceGuard"; then
  sourceGuardSetSourced "sourceGuard" "${BASH_SOURCE[0]}"
  if sourceGuardHasSourced "sourceGuard"; then
    readonly -f sourceGuardArgumentCheck
    readonly -f sourceGuardHasSourced
    readonly -f sourceGuardPrintCurrent
    readonly -f sourceGuardPrintSourced
    readonly -f sourceGuardSetSourced
    readonly -f sourceGuard
  fi
fi

return 0
