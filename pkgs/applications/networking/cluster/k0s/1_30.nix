{
  version = "1.30.4+k0s.0";
  srcs = {
    armv7l-linux = {
      url = "https://github.com/k0sproject/k0s/releases/download/v1.30.4+k0s.0/k0s-v1.30.4+k0s.0-arm";
      hash = "sha256-e9YpqLUVxlnabdjdaA4q963Li0BURCQ/Xa3oxTeh7Bo=";
    };
    aarch64-linux = {
      url = "https://github.com/k0sproject/k0s/releases/download/v1.30.4+k0s.0/k0s-v1.30.4+k0s.0-arm64";
      hash = "sha256-N1dhnQkgyUczDO0RRvEIoRbFXO4gpUuvuLayjb6eTdA=";
    };
    x86_64-linux = {
      url = "https://github.com/k0sproject/k0s/releases/download/v1.30.4+k0s.0/k0s-v1.30.4+k0s.0-amd64";
      hash = "sha256-cOPWukAEOiSFtmZQ7JLgHjfq9dkYyCKMtdvXcBKNKfk=";
    };
  };
}
