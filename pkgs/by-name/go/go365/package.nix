{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go365";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "optiv";
    repo = "Go365";
    rev = "refs/tags/v${version}";
    hash = "sha256-jmsbZrqc6XogUhuEWcU59v88id2uLqN/68URwylzWZI=";
  };

  vendorHash = "sha256-Io+69kIW4DV2EkA73pjaTcTRbDSYBf61R7F+141Jojs=";

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mv $out/bin/Go365 $out/bin/$pname
  '';

  meta = with lib; {
    description = "Office 365 enumeration tool";
    homepage = "https://github.com/optiv/Go365";
    changelog = "https://github.com/optiv/Go365/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "Go365";
  };
}
