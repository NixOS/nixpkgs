hardeningFlags=(fortify stackprotector pic strictoverflow format relro bindnow)
# Intentionally word-split in case 'hardeningEnable' is defined in
# Nix. Also, our bootstrap tools version of bash is old enough that
# undefined arrays trip `set -u`.
if [[ -v hardeningEnable[@] ]]; then
  hardeningFlags+=(${hardeningEnable[@]})
fi
hardeningCFlags=()
hardeningLDFlags=()

declare -A hardeningDisableMap

# Intentionally word-split in case 'hardeningDisable' is defined in Nix.
for flag in ${hardeningDisable[@]:-IGNORED_KEY} @hardening_unsupported_flags@
do
  hardeningDisableMap[$flag]=1
done

if (( "${NIX_DEBUG:-0}" >= 1 )); then
  printf 'HARDENING: disabled flags:' >&2
  (( "${#hardeningDisableMap[@]}" )) && printf ' %q' "${!hardeningDisableMap[@]}" >&2
  echo >&2
fi

if [[ -z "${hardeningDisableMap[all]:-}" ]]; then
  if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo 'HARDENING: Is active (not completely disabled with "all" flag)' >&2;
  fi
  for flag in "${hardeningFlags[@]}"
  do
    if [[ -z "${hardeningDisableMap[$flag]:-}" ]]; then
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
            hardeningLDFlags+=('-pie')
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
    fi
  done
fi
