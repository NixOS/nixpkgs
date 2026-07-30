fn expect {|key expected|
  var actual = $buildinfo[$key]
  if (not-eq $actual $expected) {
    fail '$buildinfo['$key']: expected '(to-string $expected)', got '(to-string $actual)
  }
}

expect version @version@
