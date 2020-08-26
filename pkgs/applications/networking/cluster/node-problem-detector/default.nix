{ stdenv, buildGoModule, fetchFromGitHub, systemd }:

buildGoModule rec {
  pname = "node-problem-detector";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sga5l8bvqgm0j71yj3l1ykqvchxa7cg8pkfvjsrqlikgrfb54f3";
  };

  vendorSha256 = null;

  doCheck = false;

  # Optionally, a log counter binary can be created to parse journald logs.
  # The binary is dynamically linked against systemd libraries, making it a
  # Linux-only feature. See 'ENABLE_JOURNALD' upstream:
  # https://github.com/kubernetes/node-problem-detector/blob/master/Makefile
  subPackages = [ "cmd/nodeproblemdetector" ] ++
    stdenv.lib.optionals stdenv.isLinux [ "cmd/logcounter" ];

  preBuild = ''
    export CGO_ENABLED=${if stdenv.isLinux then "1" else "0"}
  '';

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ systemd ];

  buildFlags = "-mod vendor" +
    stdenv.lib.optionalString stdenv.isLinux " -tags journald";

  buildFlagsArray = [
    "-ldflags="
    "-X k8s.io/${pname}/pkg/version.version=v${version}"
  ];

  meta = with stdenv.lib; {
    description = "Various problem detectors running on the Kubernetes nodes";
    homepage = "https://github.com/kubernetes/node-problem-detector";
    changelog = "https://github.com/kubernetes/node-problem-detector/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lbpdt ];
  };
}
