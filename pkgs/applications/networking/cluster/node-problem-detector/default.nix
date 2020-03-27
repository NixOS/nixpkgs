{ stdenv, buildGoModule, fetchFromGitHub, systemd }:

buildGoModule rec {
  pname = "node-problem-detector";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = pname;
    rev = "v${version}";
    sha256 = "02avknglmkr9k933a64hkw0rjfxvyh4sc3x70p41b8q2g6vzv2gs";
  };

  # Project upstream recommends building through vendoring
  overrideModAttrs = (_: {
    buildCommand = ''
      echo "Skipping go.mod, using vendoring instead." && touch $out
    '';
  });

  modSha256 = "0ip26j2h11n1kgkz36rl4akv694yz65hr72q4kv4b3lxcbi65b3p";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ lbpdt ];
  };
}
