{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-4MZwD2jgjOrBTtkjxW0XH+lZfP8wj7Z6eg7LwFziCPU=";
      hash_darwin_aarch64 =
        "sha256-P9qi8rR8DW+WOT+ev2EgA93StnGrBiIHu2UbkEhS+0M=";
      hash_linux = "sha256-eudgRu3OMuTBTeX8zrm6ShgmjcsNhzaBYEAP/4n1SJk=";
      version = "124.0.6367.155";
    };
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
    };
    hash = "sha256-Qv1xYofY4Tgj+WT1a8ehOo7R52CwZz2vCK9MDSnjmsg=";
    hash_deb_amd64 = "sha256-lFG5l3K2Yo1BYbXS9bK+9gWx6JxFrPxpT+zI7dBXQ6E=";
    version = "124.0.6367.155";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
      ungoogled-patches = {
        hash = "sha256-RS6flauUQjd+NPqUIppwlgtjOKxJa5+OTnL4aI3gRcs=";
        rev = "124.0.6367.155-1";
      };
    };
    hash = "sha256-Qv1xYofY4Tgj+WT1a8ehOo7R52CwZz2vCK9MDSnjmsg=";
    hash_deb_amd64 = "sha256-lFG5l3K2Yo1BYbXS9bK+9gWx6JxFrPxpT+zI7dBXQ6E=";
    version = "124.0.6367.155";
  };
}
