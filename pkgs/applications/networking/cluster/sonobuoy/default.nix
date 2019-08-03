{ lib, buildGoPackage, fetchFromGitHub }:

# SHA of ${version} for the tool's help output
let rev = "7ad367535a6710802085d41e0dbb53df359b9882";
in
buildGoPackage rec {
  pname = "sonobuoy";
  version = "0.15.0";

  goPackagePath = "github.com/heptio/sonobuoy";

  buildFlagsArray =
    let t = "${goPackagePath}";
    in ''
      -ldflags=
        -s -X ${t}/pkg/buildinfo.Version=${version}
           -X ${t}/pkg/buildinfo.GitSHA=${rev}
           -X ${t}/pkg/buildDate=unknown
    '';

  src = fetchFromGitHub {
    sha256 = "0dkmhmr7calk8mkdxfpy3yjzk10ja4gz1jq8pgk3v8rh04f4h1x5";
    rev = "v${version}";
    repo = "sonobuoy";
    owner = "heptio";
  };

  meta = with lib; {
    description = ''
      Diagnostic tool that makes it easier to understand the
      state of a Kubernetes cluster.
    '';
    longDescription = ''
      Sonobuoy is a diagnostic tool that makes it easier to understand the state of
      a Kubernetes cluster by running a set of Kubernetes conformance tests in an
      accessible and non-destructive manner.
    '';

    homepage = "https://github.com/heptio/sonobuoy";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos ];
  };
}
