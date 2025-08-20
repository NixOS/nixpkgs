{
  lib,
  stdenv,
  fetchFromGitHub,
  libxml2,
  curl,
  libseccomp,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "rdrview";
  version = "unstable-2021-05-30";

  src = fetchFromGitHub {
    owner = "eafer";
    repo = "rdrview";
    rev = "444ce3d6efd8989cd6ecfdc0560071b20e622636";
    sha256 = "02VC8r8PdcAfMYB0/NtbPnhsWatpLQc4mW4TmSE1+zk=";
  };

  buildInputs = [
    libxml2
    curl
    libseccomp
  ];
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 rdrview -t $out/bin
    installManPage rdrview.1
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Command line tool to extract main content from a webpage";
    homepage = "https://github.com/eafer/rdrview";
    license = licenses.asl20;
    maintainers = with maintainers; [ djanatyn ];
    mainProgram = "rdrview";
  };
}
