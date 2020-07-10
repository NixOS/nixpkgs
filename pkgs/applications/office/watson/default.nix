{ stdenv, fetchFromGitHub, pythonPackages, fetchpatch, installShellFiles }:

with pythonPackages;

buildPythonApplication rec {
  pname = "watson";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "TailorDev";
    repo = "Watson";
    rev = version;
    sha256 = "0f0ldwadjf0xncx3m4w4wwqddd4wjwcsrbhby8vgsnqsn48dnfcx";
  };

  patches = [
    # https://github.com/TailorDev/Watson/pull/380
    # The nixpkgs' arrow version is too new / not supported by Watson's latest release.
    (fetchpatch {
      url = "https://github.com/TailorDev/Watson/commit/69b9ad25551525d52060f7fb2eef3653e872a455.patch";
      sha256 = "0zrswgr0y219f92zi41m7cymfaspkhmlada4v9ijnsjjdb4bn2c9";
    })
  ];

  checkPhase = ''
    pytest -vs tests
  '';

  postInstall = ''
    installShellCompletion --bash --name watson watson.completion
    installShellCompletion --zsh --name _watson watson.zsh-completion
  '';

  checkInputs = [ py pytest pytest-datafiles pytest-mock pytestrunner ];
  propagatedBuildInputs = [ arrow click click-didyoumean requests ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with stdenv.lib; {
    homepage = "https://tailordev.github.io/Watson/";
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong ];
  };
}
