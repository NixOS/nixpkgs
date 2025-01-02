{ fastjar, testers }:

testers.testVersion {
  package = fastjar;
  command = "grepjar --version";
}
