{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zh0YYJoljcOQz0ltAk+UBScSGZhsoSqIa+F0Qm4/3iw=";
  };

  cargoHash = "sha256-G7b1BBlVMPtfEWfIXIMH4N+Avt9vtEcCG1ctrja5Ttc=";

  # The tests require contacting external servers.
  doCheck = false;

  meta = {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
})
