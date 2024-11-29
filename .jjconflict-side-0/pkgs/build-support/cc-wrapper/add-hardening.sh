declare -a hardeningCFlagsAfter=()
declare -a hardeningCFlagsBefore=()

declare -A hardeningEnableMap=()

# Intentionally word-split in case 'NIX_HARDENING_ENABLE' is defined in Nix. The
# array expansion also prevents undefined variables from causing trouble with
# `set -u`.
for flag in ${NIX_HARDENING_ENABLE_@suffixSalt@-}; do
  hardeningEnableMap["$flag"]=1
done

# fortify3 implies fortify enablement - make explicit before
# we filter unsupported flags because unsupporting fortify3
# doesn't mean we should unsupport fortify too
if [[ -n "${hardeningEnableMap[fortify3]-}" ]]; then
  hardeningEnableMap["fortify"]=1
fi

# Remove unsupported flags.
for flag in @hardening_unsupported_flags@; do
  unset -v "hardeningEnableMap[$flag]"
  # fortify being unsupported implies fortify3 is unsupported
  if [[ "$flag" = 'fortify' ]] ; then
    unset -v "hardeningEnableMap['fortify3']"
  fi
done

# now make fortify and fortify3 mutually exclusive
if [[ -n "${hardeningEnableMap[fortify3]-}" ]]; then
  unset -v "hardeningEnableMap['fortify']"
fi

if (( "${NIX_DEBUG:-0}" >= 1 )); then
  declare -a allHardeningFlags=(fortify fortify3 shadowstack stackprotector stackclashprotection pacret pie pic strictoverflow format trivialautovarinit zerocallusedregs)
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
    fortify | fortify3)
      # Use -U_FORTIFY_SOURCE to avoid warnings on toolchains that explicitly
      # set -D_FORTIFY_SOURCE=0 (like 'clang -fsanitize=address').
      hardeningCFlagsBefore+=('-O2' '-U_FORTIFY_SOURCE')
      # Unset any _FORTIFY_SOURCE values the command-line may have set before
      # enforcing our own value, avoiding (potentially fatal) redefinition
      # warnings
      hardeningCFlagsAfter+=('-U_FORTIFY_SOURCE')
      case $flag in
        fortify)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling fortify >&2; fi
          hardeningCFlagsAfter+=('-D_FORTIFY_SOURCE=2')
        ;;
        fortify3)
          if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling fortify3 >&2; fi
          hardeningCFlagsAfter+=('-D_FORTIFY_SOURCE=3')
        ;;
        *)
          # Ignore unsupported.
          ;;
      esac
      ;;
    shadowstack)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling shadowstack >&2; fi
      hardeningCFlagsBefore+=('-fcf-protection=return')
      ;;
    pacret)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling pacret >&2; fi
      hardeningCFlagsBefore+=('-mbranch-protection=pac-ret')
      ;;
    stackprotector)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling stackprotector >&2; fi
      hardeningCFlagsBefore+=('-fstack-protector-strong' '--param' 'ssp-buffer-size=4')
      ;;
    stackclashprotection)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling stack-clash-protection >&2; fi
      hardeningCFlagsBefore+=('-fstack-clash-protection')
      ;;
    pie)
      # NB: we do not use `+=` here, because PIE flags must occur before any PIC flags
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling CFlags -fPIE >&2; fi
      hardeningCFlagsBefore=('-fPIE' "${hardeningCFlagsBefore[@]}")
      if [[ ! (" ${params[*]} " =~ " -shared " || " ${params[*]} " =~ " -static ") ]]; then
        if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling LDFlags -pie >&2; fi
        hardeningCFlagsBefore=('-pie' "${hardeningCFlagsBefore[@]}")
      fi
      ;;
    pic)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling pic >&2; fi
      hardeningCFlagsBefore+=('-fPIC')
      ;;
    strictoverflow)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling strictoverflow >&2; fi
      if (( @isClang@ )); then
        # In Clang, -fno-strict-overflow only serves to set -fwrapv and is
        # reported as an unused CLI argument if -fwrapv or -fno-wrapv is set
        # explicitly, so we side step that by doing the conversion here.
        #
        # See: https://github.com/llvm/llvm-project/blob/llvmorg-16.0.6/clang/lib/Driver/ToolChains/Clang.cpp#L6315
        #
        hardeningCFlagsBefore+=('-fwrapv')
      else
        hardeningCFlagsBefore+=('-fno-strict-overflow')
      fi
      ;;
    trivialautovarinit)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling trivialautovarinit >&2; fi
      hardeningCFlagsBefore+=('-ftrivial-auto-var-init=pattern')
      ;;
    format)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling format >&2; fi
      hardeningCFlagsBefore+=('-Wformat' '-Wformat-security' '-Werror=format-security')
      ;;
    zerocallusedregs)
      if (( "${NIX_DEBUG:-0}" >= 1 )); then echo HARDENING: enabling zerocallusedregs >&2; fi
      hardeningCFlagsBefore+=('-fzero-call-used-regs=used-gpr')
      ;;
    *)
      # Ignore unsupported. Checked in Nix that at least *some*
      # tool supports each flag.
      ;;
  esac
done
