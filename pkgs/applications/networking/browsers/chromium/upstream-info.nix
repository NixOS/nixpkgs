{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-sRAU9RJANz+Sov6oaoZasMoaqM+mIZSDbag92wXsVCI=";
      hash_darwin_aarch64 =
        "sha256-U+PBsfpc7PNZYedHIdPnWXA9xKpRnon5vxgKKJr69ow=";
      hash_linux = "sha256-2o6LAo2pEsCi1exPv1nEMk2Tklhh49UyWaYoyQ7Df/Y=";
      version = "119.0.6045.105";
    };
    deps = {
      gn = {
        hash = "sha256-4jWqtsOBh96xbYk1m06G9hj2eQwW6buUXsxWsa5W6/4=";
        rev = "991530ce394efb58fcd848195469022fa17ae126";
        url = "https://gn.googlesource.com/gn";
        version = "2023-09-12";
      };
    };
    hash = "sha256-UR8EowMYZ668qQ/6C9C/M+0HSguyUGKVhY46FTG+ShA=";
    hash_deb_amd64 = "sha256-PIBWkCwU/7N242wR/WmpJDDJKLDGk/sJxPxa05bOQSE=";
    version = "119.0.6045.123";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-4jWqtsOBh96xbYk1m06G9hj2eQwW6buUXsxWsa5W6/4=";
        rev = "991530ce394efb58fcd848195469022fa17ae126";
        url = "https://gn.googlesource.com/gn";
        version = "2023-09-12";
      };
      ungoogled-patches = {
        hash = "sha256-4EbfM62KuG8nHrYWwp183V5G9ac7FICjpyJahnKbQjE=";
        rev = "119.0.6045.123-1";
      };
    };
    hash = "sha256-UR8EowMYZ668qQ/6C9C/M+0HSguyUGKVhY46FTG+ShA=";
    hash_deb_amd64 = "sha256-PIBWkCwU/7N242wR/WmpJDDJKLDGk/sJxPxa05bOQSE=";
    version = "119.0.6045.123";
  };
}
