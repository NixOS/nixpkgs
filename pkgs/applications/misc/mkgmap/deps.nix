{ fetchurl }:
{
  fastutil = fetchurl {
    url = "http://ivy.mkgmap.org.uk/repo/it.unimi.dsi/fastutil/6.5.15-mkg.1b/jars/fastutil.jar";
    sha256 = "0d88m0rpi69wgxhnj5zh924q4zsvxq8m4ybk7m9mr3gz1hx0yx8c";
  };
  osmpbf = fetchurl {
    url = "http://ivy.mkgmap.org.uk/repo/crosby/osmpbf/1.3.3/jars/osmpbf.jar";
    sha256 = "0zb4pqkwly5z30ww66qhhasdhdrzwmrw00347yrbgyk2ii4wjad3";
  };
  protobuf = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar";
    sha256 = "0x6c4pbsizvk3lm6nxcgi1g2iqgrxcna1ip74lbn01f0fm2wdhg0";
  };
  xpp3 = fetchurl {
    url = "https://repo1.maven.org/maven2/xpp3/xpp3/1.1.4c/xpp3-1.1.4c.jar";
    sha256 = "1f9ifnxxj295xb1494jycbfm76476xm5l52p7608gf0v91d3jh83";
  };
  jaxb-api = fetchurl {
    url = "https://repo1.maven.org/maven2/javax/xml/bind/jaxb-api/2.3.0/jaxb-api-2.3.0.jar";
    sha256 = "00rxpc0m30d3jc572ni01ryxq8gcbnr955xsabrijg9pknc0fc48";
  };
  junit = fetchurl {
    url = "https://repo1.maven.org/maven2/junit/junit/4.11/junit-4.11.jar";
    sha256 = "1zh6klzv8w30dx7jg6pkhllk4587av4znflzhxz8x97c7rhf3a4h";
  };
  hamcrest-core = fetchurl {
    url = "https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar";
    sha256 = "1sfqqi8p5957hs9yik44an3lwpv8ln2a6sh9gbgli4vkx68yzzb6";
  };
}
