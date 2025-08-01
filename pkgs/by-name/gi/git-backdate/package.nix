{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation {
  pname = "git-backdate";
  version = "2023-07-19";

  src = fetchFromGitHub {
    owner = "rixx";
    repo = "git-backdate";
    rev = "8ba5a0eba04e5559be2e4b1b6e02e62b64ca4dd8";
    sha256 = "sha256-91cEGQ0FtoiHEZHQ93jPFHF2vLoeQuBidykePFHtrsY=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 git-backdate -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Backdate a commit or range of commit to a date or range of dates";
    homepage = "https://github.com/rixx/git-backdate";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "git-backdate";
  };
}
