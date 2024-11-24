{ micro, testers }:

testers.testVersion {
  package = micro;
  command = "micro -version";
}
