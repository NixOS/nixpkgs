/goPackagePath/ && /sqlite/ {
  sqlite=1
  prev="    ] ++ (lib.optional (sqliteSupport) {"
}

sqlite && /}$/ {
  sqlite=0
  $0="    }) ++ ["
}

NR > 1 {
  print prev
}

{
  prev=$0
}

END {
  print prev
}
