{ fetchurl }:
{
  fastutil = fetchurl {
    url = "http://ivy.mkgmap.org.uk/repo/it.unimi.dsi/fastutil/6.5.15-mkg.1b/jars/fastutil.jar";
    hash = "sha256-DHUPOgz/jVxTPXN5UhHuW3+CiUjwF2lhfzyZeDOoCDU=";
  };
  osmpbf = fetchurl {
    url = "http://ivy.mkgmap.org.uk/repo/crosby/osmpbf/1.3.3/jars/osmpbf.jar";
    hash = "sha256-oynJSYxi+reyP2QAwHPlPzfYtIIQG8M5GL94yie+ZH0=";
  };
  protobuf = fetchurl {
    url = "mirror://maven/com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar";
    hash = "sha256-4MHGRXXABWAXJefGoCzr+eEoXoiPdWsqHXP/qNclzHQ=";
  };
  xpp3 = fetchurl {
    url = "mirror://maven/xpp3/xpp3/1.1.4c/xpp3-1.1.4c.jar";
    hash = "sha256-A0E5WkgbuIeAOVcUWmo3h5hT3WJekkTC6iUJ2bt1Mbk=";
  };
  jaxb-api = fetchurl {
    url = "mirror://maven/javax/xml/bind/jaxb-api/2.3.0/jaxb-api-2.3.0.jar";
    hash = "sha256-iDAHmJ03PRnzUrqXkrJd7CHcfQ4gWnEKk6OBUQG7PQM=";
  };
  junit = fetchurl {
    url = "mirror://maven/junit/junit/4.11/junit-4.11.jar";
    hash = "sha256-kKjhYD7spI5+h586+8lWBxUyKYXzmidPb2BwtD+dBv4=";
  };
  hamcrest-core = fetchurl {
    url = "mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar";
    hash = "sha256-Zv3vkelzk0jfeglqo4SlaF9Oh1WEzOiThqekclHE2Ok=";
  };
}
