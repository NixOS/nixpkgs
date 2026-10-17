{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "pipeform";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "magodo";
    repo = "pipeform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qmA+4xNstR1VRoYZW+xukNCEuEq6aGVkja3DYxZZVyY=";
  };

  vendorHash = "sha256-QI6Rnq3JxQuKRMkeo9Fvv6wfcTMgDEQ3Ot+es3IAUIA=";

  subPackages = [ "." ];

  __structuredAttrs = true;

  # Clipboard support
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  meta = {
    description = "TUI for Terraform runtime progress";
    homepage = "https://github.com/magodo/pipeform";
    license = lib.licenses.mpl20;
    mainProgram = "pipeform";
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
