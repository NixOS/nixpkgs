{ micro-headless, testers }:

testers.testVersion {
  package = micro-headless;
  command = "micro -version";
}
