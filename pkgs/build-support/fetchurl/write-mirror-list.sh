if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi

source $stdenv/setup

# !!! this is kinda hacky.
set | grep -E '^[a-zA-Z]+=.*://' > $out
