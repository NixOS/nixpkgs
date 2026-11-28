#!/usr/bin/env bash
# set -uTEe -o pipefail;

__usage__() {
  local _message="${1}";

  cat <<EOF
Insert iptables rule before given target or append rule if target is not found

-h,   --help
  Print this message and exit

-t,  --target "<REGEXP>"
  Pattern to match against 'iptables -S' or 'iptables -t nat' output to insert rules before

--
  Must be declared as final option, all remaining words will be passed to iptables with minimal modification

Example, supose Tor is listening on address '192.168.4.2' on various ports for
client from '192.168.4.19' but Docker is gobbling all local address packets,
this script may be used for injecting a jump to a custom chain before Docker;

  iptables -t nat -N tor-middle-box
  iptables -t nat -A tor-middle-box -p udp --dport 53 -j DNAT --to-destination 192.168.4.2:9053
  iptables -t nat -A tor-middle-box -p udp --dport 5353 -j DNAT --to-destination 192.168.4.2:9053
  iptables -t nat -A tor-middle-box -p tcp --dport 9050 -j DNAT --to-destination 192.168.4.2:9050
  iptables -t nat -A tor-middle-box -p tcp ! --dport 9040 --syn -j DNAT --to-destination 192.168.4.2:9040

  ./iptables-insert-before.sh --target '-j DOCKER$' -- -t nat -A PREROUTING -s 192.168.4.19 -j tor-middle-box
EOF

  if (( ${#_message} )); then
    printf '\n';
    printf >&2 '%s\n' "${_message}";
  fi
}

while (( ${#@} )); do
  case "${1}" in
    -t|--target)
      _target="${2}";
      shift 2;
    ;;
    --)
      shift 1;
      _rules=( "${@}" );
      shift "${#@}";
    ;;
    -h|--help)
      __usage__ '';
      exit 0;
    ;;
    *)
      __usage__ "Error: unrecognized argument(s): ${*}";
      exit 1;
    ;;
  esac
done

if ! (( ${#_target} )); then
  __usage__ 'Error: missing required value for --target';
  exit 1;
elif ! (( ${#_rules[@]} )); then
  __usage__ 'Error: missing required values after --';
  exit 1;
fi

case "${_rules[*]}" in
  '-t '*|'--table '*)
    _table=( "${_rules[@]:0:2}" );
    _chain_name="${_rules[3]}";
  ;;
  *)
    _chain_name="${_rules[1]}";
  ;;
esac

_insert_rulenum="$(
  iptables "${_table[@]}" -S "${_chain_name:?Undefined chain name}" |
    awk -v _target="${_target}" '{
      if ($0 ~ _target) {
        _line_number = NR;
        nextfile;
      }
  }
  END {
    if (_line_number) {
      print _line_number - 1;
    } else {
      print NR;
    }
  }'
)";

case "${_rules[*]}" in
  '-t '*|'--table '*)
    _args_check=( "${_rules[@]:0:2}" '-C' "${_rules[@]:3}" );
    _args_delete=( "${_rules[@]:0:2}" '-D' "${_rules[@]:3}" );
    _args_insert=( "${_rules[@]:0:2}" '-I' "${_chain_name}" "${_insert_rulenum}" "${_rules[@]:4}" );
  ;;
  *)
    _args_check=( '-C' "${_rules[@]:1}" );
    _args_delete=( '-D' "${_rules[@]:1}" );
    _args_insert=( '-I' "${_chain_name}" "${_insert_rulenum}" "${_rules[@]:2}" );
  ;;
esac

if iptables "${_args_check[@]}" 1>/dev/null 2>&1; then
  iptables "${_args_delete[@]}";
fi
iptables "${_args_insert[@]}";

