{ fetchFromGitHub }:
# To cache schema as a package so network calls are not
# necessary at runtime, allowing use in package builds you can use the following:

#   KUBEVAL_SCHEMA_LOCATION="file:///${kubeval-schema}";
(fetchFromGitHub {
  name = "kubeval-schema";
  owner = "instrumenta";
  repo = "kubernetes-json-schema";
  rev = "6a498a60dc68c5f6a1cc248f94b5cd1e7241d699";
  hash = "sha256-WYpurBFjY+XAQey/oxyI3s1ruNwInUeF0wcSO1QVNfk=";
})
// {
  # the schema is huge (> 7GB), we don't get any benefit from building int on hydra
  meta.hydraPlatforms = [ ];
}
