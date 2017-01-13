source $stdenv/setup

# !!! this is kinda hacky.
set | egrep '^[a-zA-Z]\+=.*://' > $out
