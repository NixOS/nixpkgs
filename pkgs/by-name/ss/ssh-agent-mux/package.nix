{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssh,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ssh-agent-mux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "overhacked";
    repo = "ssh-agent-mux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tIGrENlZcT9fGke6MRnsLsmm+kb0Mm3C6DckkZi8hpE=";
  };

  cargoHash = "sha256-u5kGYCYDvEhSuGOLnhdt9IpRwzllXbSJDwY1XzpHBCc=";

  nativeCheckInputs = [ openssh ];

  meta = {
    description = "A proxy that multiplexes SSH agent requests to multiple upstream agents";
    homepage = "https://github.com/overhacked/ssh-agent-mux";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kalbasit ];
    mainProgram = "ssh-agent-mux";
  };
})
