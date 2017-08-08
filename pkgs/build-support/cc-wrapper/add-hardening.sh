allHardeningFlags=(fortify stackprotector pie pic strictoverflow format relro bindnow)
hardeningCFlags=()

declare -A hardeningDisableMap=()
declare -A hardeningEnableMap=()

# Create table of unsupported flags for this toolchain.
for flag in @hardening_unsupported_flags@; do
  hardeningDisableMap[$flag]=1
done

# Intentionally word-split in case 'NIX_HARDENING_ENABLE' is defined in Nix. The
# array expansion also prevents undefined variables from causing trouble with
# `set -u`.
for flag in ${NIX_HARDENING_ENABLE-}; do
  if [[ -z "${hardeningDisableMap[$flag]-}" ]]; then
    hardeningEnableMap[$flag]=1
  fi
done

if (( "${NIX_DEBUG:-0}" >= 1 )); then
  # Determine which flags were effectively disabled so we can report below.
  for flag in ${allHardeningFlags[@]}; do
    if [[ -z "${hardeningEnableMap[$flag]-}" ]]; then
      hardeningDisableMap[$flag]=1
    fi
  done

  printf 'HARDENING: disabled flags:' >&2
  (( "${#hardeningDisableMap[@]}" )) && printf ' %q' "${!hardeningDisableMap[@]}" >&2
  echo >&2
fi

if (( "${#hardeningEnableMap[@]}" )); then
  if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo 'HARDENING: Is active (not completely disabled with "all" flag)' >&2;
  fi
  for flag in "${!hardeningEnableMap[@]}"; do
      case $flag in
        fortify)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling fortify >&2; fi
          hardeningCFlags+=('-O2' '-D_FORTIFY_SOURCE=2')
          ;;
        stackprotector)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling stackprotector >&2; fi
          hardeningCFlags+=('-fstack-protector-strong' '--param' 'ssp-buffer-size=4')
          ;;
        pie)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling CFlags -fPIE >&2; fi
          hardeningCFlags+=('-fPIE')
          if [[ ! ("$*" =~ " -shared " || "$*" =~ " -static ") ]]; then
            if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling LDFlags -pie >&2; fi
            hardeningCFlags+=('-pie')
          fi
          ;;
        pic)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling pic >&2; fi
          hardeningCFlags+=('-fPIC')
          ;;
        strictoverflow)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling strictoverflow >&2; fi
          hardeningCFlags+=('-fno-strict-overflow')
          ;;
        format)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling format >&2; fi
          hardeningCFlags+=('-Wformat' '-Wformat-security' '-Werror=format-security')
          ;;
        *)
          # Ignore unsupported. Checked in Nix that at least *some*
          # tool supports each flag.
          ;;
      esac
  done
fi
