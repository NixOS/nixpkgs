{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${version}";
    hash = "sha256-A1dZH7qeQTsMaJdB4UejpP/HD5tE07gCHFv2Mb1ZXWY=";
  };

  cargoHash = "sha256-Iwm1VGxIBfuT3nXk5Si9gpDFJRjHBOc3nfE8DFvI5YE=";

  __darwinAllowLocalNetworking = true;

  # On Darwin, sendme invokes CoreFoundation APIs that read ICU data from the
  # system. Ensure these paths are accessible in the sandbox to avoid segfaults
  # during checkPhase.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

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
