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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j8u6/Hn6v2OMCTks6O/r4SpBoTvaOl/M7r6GYgECUpw=";
  };

  vendorHash = "sha256-RezpLJzSL6TfS60DJOdznLKLPUdFcqTBZBQxw5UWavM=";

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
