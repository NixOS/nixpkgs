{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${version}";
    hash = "sha256-21JNyncChl8rv3IDdvYRF/nvMpAGCBps4xsBP9b/1lA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1VVpjeGU6/+apTHv7klo7FkAQ3AVjiziQRNI7yFbvh0=";

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
