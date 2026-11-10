#compdef ks

_ks() {
  local -a commands
  commands=(
    "add:Add a secret (-n for secure note)"
    "show:Decrypt and reveal a secret"
    "cp:Copy a secret to the clipboard"
    "rm:Remove a secret from the keychain"
    "ls:List all secrets in the keychain"
    "rand:Generate a random secret (optionally specify size)"
    "init:Initialize the selected keychain"
    "help:Show help information"
    "version:Print the version number"
  )

  local context curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments \
    '(-k)-k[Specify keychain]:keychain name:_files' \
    '1:command:->command' \
    '*::arguments:->args'

  case $state in
    command)
      _describe -t commands 'ks commands' commands
      ;;
    args)
      case $line[1] in
        add)
          _arguments \
            '(-n)-n[Add a secure note instead of a password]' \
            '1:key[The name of the secret to add]' \
            '2:value[The value of the secret to add]' \
            '*::values:filename'
          ;;
        show|cp|rm)
          local -a secrets
          secrets=("${(@f)$(ks ls 2>/dev/null)}")
          _describe -t secrets 'secrets' secrets
          ;;
        ls)
          # No additional arguments for `ks ls`
          ;;
        rand)
          _arguments '1:size[The size of the random secret to generate]'
          ;;
        *)
          ;;
      esac
      ;;
  esac
}

