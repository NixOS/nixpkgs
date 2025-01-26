_nixos_firewall_tool() {
  case "${COMP_CWORD}" in
    1)
      COMPREPLY=($(compgen -W "open show reset" -- "${COMP_WORDS[1]}"))
      ;;
    2)
      case "${COMP_WORDS[1]}" in
        "open")
          COMPREPLY=($(compgen -W "tcp udp" -- "${COMP_WORDS[2]}"))
          ;;
        *)
          ;;
      esac
      ;;
    *)
      ;;
  esac
}

complete -F _nixos_firewall_tool nixos-firewall-tool
