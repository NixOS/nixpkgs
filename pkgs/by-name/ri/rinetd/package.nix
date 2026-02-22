{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  rinetd,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rinetd";
  version = "0.73";

  src = fetchFromGitHub {
    owner = "samhocevar";
    repo = "rinetd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W8PLGd3RwmBTh1kw3k8+ZfP6AzRhZORCkxZzQ9ZbPN4=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  preConfigure = ''
    ./bootstrap
  '';

  passthru.tests.version = testers.testVersion {
    package = rinetd;
    command = "rinetd --version";
  };

  meta = {
    description = "TCP/UDP port redirector";
    homepage = "https://github.com/samhocevar/rinetd";
    changelog = "https://github.com/samhocevar/rinetd/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "rinetd";
  };
})
