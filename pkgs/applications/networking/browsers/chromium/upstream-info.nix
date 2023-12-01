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
    hash = "sha256-LqAORwZRyS9ASo0U+iVi9srEKYoSBG5upjqi5F65ITg=";
    hash_deb_amd64 = "sha256-9nZjyJnXvOO1iZea3mdsj5FYkylrWnhColZ+q+X/xcU=";
    version = "119.0.6045.199";
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
        hash = "sha256-ZcE5rmreXt4X+PuMalNRE7FakMIMOCyZQfhIhKDSxMg=";
        rev = "119.0.6045.199-1";
      };
    };
    hash = "sha256-LqAORwZRyS9ASo0U+iVi9srEKYoSBG5upjqi5F65ITg=";
    hash_deb_amd64 = "sha256-9nZjyJnXvOO1iZea3mdsj5FYkylrWnhColZ+q+X/xcU=";
    version = "119.0.6045.199";
  };
}
