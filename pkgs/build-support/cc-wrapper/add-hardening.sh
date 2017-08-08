hardeningFlags=(fortify stackprotector pic strictoverflow format relro bindnow)
# Intentionally word-split in case 'hardeningEnable' is defined in Nix.
hardeningFlags+=(${hardeningEnable[@]})
hardeningCFlags=()
hardeningLDFlags=()

declare -A hardeningDisableMap

# Intentionally word-split in case 'hardeningDisable' is defined in Nix. The
# array expansion also prevents undefined variables from causing trouble with
# `set -u`.
for flag in ${hardeningDisable[@]} @hardening_unsupported_flags@
do
  hardeningDisableMap[$flag]=1
done

if [[ -n "$NIX_DEBUG" ]]; then
  printf 'HARDENING: disabled flags:' >&2
  (( "${#hardeningDisableMap[@]}" )) && printf ' %q' "${!hardeningDisableMap[@]}" >&2
  echo >&2
fi

if [[ -z "${hardeningDisableMap[all]}" ]]; then
  if [[ -n "$NIX_DEBUG" ]]; then
    echo 'HARDENING: Is active (not completely disabled with "all" flag)' >&2;
  fi
  for flag in "${hardeningFlags[@]}"
  do
    if [[ -z "${hardeningDisableMap[$flag]}" ]]; then
      case $flag in
        fortify)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling fortify >&2; fi
          hardeningCFlags+=('-O2' '-D_FORTIFY_SOURCE=2')
          ;;
        stackprotector)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling stackprotector >&2; fi
          hardeningCFlags+=('-fstack-protector-strong' '--param' 'ssp-buffer-size=4')
          ;;
        pie)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling CFlags -fPIE >&2; fi
          hardeningCFlags+=('-fPIE')
          if [[ ! ("$*" =~ " -shared " || "$*" =~ " -static ") ]]; then
            if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling LDFlags -pie >&2; fi
            hardeningLDFlags+=('-pie')
          fi
          ;;
        pic)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling pic >&2; fi
          hardeningCFlags+=('-fPIC')
          ;;
        strictoverflow)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling strictoverflow >&2; fi
          hardeningCFlags+=('-fno-strict-overflow')
          ;;
        format)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling format >&2; fi
          hardeningCFlags+=('-Wformat' '-Wformat-security' '-Werror=format-security')
          ;;
        relro)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling relro >&2; fi
          hardeningLDFlags+=('-z' 'relro')
          ;;
        bindnow)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling bindnow >&2; fi
          hardeningLDFlags+=('-z' 'now')
          ;;
        *)
          echo "Hardening flag unknown: $flag" >&2
          ;;
      esac
    fi
  done
fi
