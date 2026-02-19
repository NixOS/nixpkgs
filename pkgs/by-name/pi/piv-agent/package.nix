{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "piv-agent";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fFnUWV+q9M0QS84N59DKMVQ+uTG8adZaUi1fPipwF/U=";
  };

  vendorHash = "sha256-j8Sq8j99APyOmfgpqkaVTgawJ0ahToHQt71TMBoafm0=";

  subPackages = [ "cmd/piv-agent" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.shortCommit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ pcsclite ];

  meta = {
    description = "SSH and GPG agent which you can use with your PIV hardware security device (e.g. a Yubikey)";
    homepage = "https://github.com/smlx/piv-agent";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "piv-agent";
  };
})
