declare -a hardeningCFlags=()

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
  declare -a allHardeningFlags=(cfprotection format fortify glibcxxassertions pic pie stackclashprotection stackprotector strictoverflow)
  declare -A hardeningDisableMap=()

  # Determine which flags were effectively disabled so we can report below.
  for flag in "${allHardeningFlags[@]}"; do
    if [[ -z "${hardeningEnableMap[$flag]-}" ]]; then
      hardeningDisableMap["$flag"]=1
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
    cfprotection)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling cfprotection >&2; fi
      hardeningCFlags+=('-fcf-protection')
      ;;
    format)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling format >&2; fi
      hardeningCFlags+=('-Wformat' '-Wformat-security' '-Werror=format-security')
      ;;
    fortify)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling fortify >&2; fi
      hardeningCFlags+=('-O2' '-D_FORTIFY_SOURCE=2')
      ;;
    glibcxxassertions)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling glibcxxassertions >&2; fi
      hardeningCFlags+=('-D_GLIBCXX_ASSERTIONS')
      ;;
    pic)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling pic >&2; fi
      hardeningCFlags+=('-fPIC')
      ;;
    pie)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling CFlags -fPIE >&2; fi
      hardeningCFlags+=('-fPIE')
      if [[ ! ("$*" =~ " -shared " || "$*" =~ " -static ") ]]; then
        if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling LDFlags -pie >&2; fi
        hardeningCFlags+=('-pie')
      fi
      ;;
    stackclashprotection)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling stackclashprotection >&2; fi
      hardeningCFlags+=('-fstack-clash-protection')
      ;;
    stackprotector)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling stackprotector >&2; fi
      hardeningCFlags+=('-fstack-protector-strong' '--param' 'ssp-buffer-size=4')
      ;;
    strictoverflow)
       if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling strictoverflow >&2; fi
      hardeningCFlags+=('-fno-strict-overflow')
      ;;
    *)
      # Ignore unsupported. Checked in Nix that at least *some*
      # tool supports each flag.
      ;;
  esac
done
