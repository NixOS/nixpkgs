{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${version}";
    hash = "sha256-zh0YYJoljcOQz0ltAk+UBScSGZhsoSqIa+F0Qm4/3iw=";
  };

  cargoHash = "sha256-G7b1BBlVMPtfEWfIXIMH4N+Avt9vtEcCG1ctrja5Ttc=";

  # The tests require contacting external servers.
  doCheck = false;

  meta = with lib; {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
}
