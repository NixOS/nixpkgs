{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-cWY8P3D+PrIlbEdMYPp+4cFQZfOLbGeebC1Glg53Sx4=";
      hash_darwin_aarch64 =
        "sha256-Tu11SCTlB+8/ao0uS7AbknB5WuvN+cw/gHiyL6xKH1o=";
      hash_linux = "sha256-Da+xaXNNP8eRccq87LBxMb+2oXJ4WRGLdWoCAhG2yAQ=";
      version = "129.0.6668.89";
    };
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
    };
    hash = "sha256-+n9LjRLFvVB/pYkSrRCxln/Xn2paFyoY+mJGD73NtII=";
    version = "129.0.6668.89";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
      ungoogled-patches = {
        hash = "sha256-fKMa/TxQRzteLIYMy+gn5fDvxLyrqtSwXHWxle0bhsE=";
        rev = "129.0.6668.89-1";
      };
    };
    hash = "sha256-+n9LjRLFvVB/pYkSrRCxln/Xn2paFyoY+mJGD73NtII=";
    version = "129.0.6668.89";
  };
}
