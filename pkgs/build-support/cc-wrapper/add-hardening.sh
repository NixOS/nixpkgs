hardeningFlags=(fortify stackprotector pic strictoverflow format relro bindnow)
hardeningFlags+=("${hardeningEnable[@]}")
hardeningCFlags=()
hardeningLDFlags=()
hardeningDisable=${hardeningDisable:-""}

hardeningDisable+=" @hardening_unsupported_flags@"

if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: Value of '$hardeningDisable': $hardeningDisable >&2; fi

if [[ ! $hardeningDisable =~ "all" ]]; then
  if [[ -n "$NIX_DEBUG" ]]; then echo 'HARDENING: Is active (not completely disabled with "all" flag)' >&2; fi
  for flag in "${hardeningFlags[@]}"
  do
    if [[ ! "${hardeningDisable}" =~ "$flag" ]]; then
      case $flag in
        fortify)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling fortify >&2; fi
          hardeningCFlags+=('-O2' '-D_FORTIFY_SOURCE=2')
          ;;
        stackprotector)
          if [[ -n "$NIX_DEBUG" ]]; then echo HARDENING: enabling stackprotector >&2; fi
          hardeningCFlags+=('-fstack-protector-strong' '--param ssp-buffer-size=4')
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
