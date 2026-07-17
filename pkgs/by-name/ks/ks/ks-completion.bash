#!/usr/bin/env bash

_ks_completions() {
  local cur prev commands secrets
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  commands="add show cp rm ls rand init help version"

  case "$prev" in
    ks)
      # Provide top-level command suggestions
      COMPREPLY=($(compgen -W "$commands" -- "$cur"))
      return 0
      ;;
    show|cp|rm)
      # Provide dynamic completion for secrets
      if secrets=$(ks ls 2>/dev/null); then
        COMPREPLY=($(compgen -W "$secrets" -- "$cur"))
      fi
      return 0
      ;;
    add)
      # For `ks add`, suggest options for adding secrets
      COMPREPLY=($(compgen -W "-n" -- "$cur"))
      return 0
      ;;
    rand)
      # No specific completions for `ks rand`
      return 0
      ;;
  esac

  case "${COMP_WORDS[1]}" in
    ls|init|help|version)
      # No additional completions for these commands
      return 0
      ;;
  esac
}

# Register the completion function for the `ks` command
complete -F _ks_completions ks
