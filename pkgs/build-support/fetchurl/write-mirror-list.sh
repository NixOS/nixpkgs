source $stdenv/setup

# !!! this is kinda hacky.
set | grep '^[a-zA-Z]\+=.*://' > $out
