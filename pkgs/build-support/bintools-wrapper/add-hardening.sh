declare -a hardeningLDFlags=()

declare -A hardeningEnableMap=()

# Intentionally word-split in case 'NIX_HARDENING_ENABLE' is defined in Nix. The
# array expansion also prevents undefined variables from causing trouble with
# `set -u`.
for flag in ${NIX_HARDENING_ENABLE_@suffixSalt@-}; do
  hardeningEnableMap["$flag"]=1
done

# Remove unsupported flags.
for flag in @hardening_unsupported_flags@; do
  unset -v "hardeningEnableMap[$flag]"
done

if (( "${NIX_DEBUG:-0}" >= 1 )); then
  declare -a allHardeningFlags=(pie relro bindnow)
  declare -A hardeningDisableMap=()

  # Determine which flags were effectively disabled so we can report below.
  for flag in "${allHardeningFlags[@]}"; do
    if [[ -z "${hardeningEnableMap[$flag]-}" ]]; then
      hardeningDisableMap[$flag]=1
    fi
  done

  printf 'HARDENING: disabled flags:' >&2
  (( "${#hardeningDisableMap[@]}" )) && printf ' %q' "${!hardeningDisableMap[@]}" >&2
  echo >&2

  if (( "${#hardeningEnableMap[@]}" )); then
    echo 'HARDENING: Is active (not completely disabled with "all" flag)' >&2;
  fi
fi

for flag in "${!hardeningEnableMap[@]}"; do
  case $flag in
    pie)
      if [[ ! (" ${params[*]} " =~ " -shared " \
            || " ${params[*]} " =~ " -static " \
            || " ${params[*]} " =~ " -r " \
            || " ${params[*]} " =~ " -Ur " \
            || " ${params[*]} " =~ " -i ") ]]; then
        if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling LDFlags -pie >&2; fi
        hardeningLDFlags+=('-pie')
      fi
      ;;
    relro)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling relro >&2; fi
      hardeningLDFlags+=('-z' 'relro')
      ;;
    bindnow)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling bindnow >&2; fi
      hardeningLDFlags+=('-z' 'now')
      ;;
    *)
      # Ignore unsupported. Checked in Nix that at least *some*
      # tool supports each flag.
      ;;
  esac
done
