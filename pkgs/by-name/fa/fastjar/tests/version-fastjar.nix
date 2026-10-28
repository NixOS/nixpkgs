{ fastjar, testers }:

testers.testVersion {
  package = fastjar;
  command = "fastjar --version";
}
