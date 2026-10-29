{
  rustPlatform,
  fetchFromGitLab,
  ookla-speedtest,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulse-agent";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "team-olilo";
    repo = "pulse-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6VMld11B+Vy4sCnsrs3042TB42nOM1WTPXQutvRcgjs=";
  };

  cargoHash = "sha256-Hp7pF+K8HfXhdiAOaZB9xWac04g6jl8g9rnSQM3RAEw=";

  buildInputs = [ ookla-speedtest ];

  postInstall = ''
    mkdir -p $out/usr/lib/systemd/system

    substitute ./systemd/pulse-agent.service $out/usr/lib/systemd/system/pulse-agent.service \
      --replace /usr/local/bin/pulse-agent $out/bin/pulse-agent
  '';
})
