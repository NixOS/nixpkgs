{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Yi0GM9gNQ1lEuuwS49asbhA1b2iUfBDnT06sPX7UuKM=";
  };

  cargoHash = "sha256-Nkr/8KoNZCTPWcpnqdfB+D3VpL4ABRlvi5nxhMuCw1U=";

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
