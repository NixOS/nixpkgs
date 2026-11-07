{
  lib,
  rustPlatform,
  fetchFromGitLab,
  ookla-speedtest,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulse-agent";
  version = "0.2.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "team-olilo";
    repo = "pulse-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Ja8/JTa1ENLXkrZrz861xhoc72IzcpBS8GgD5lwSmg=";
  };

  cargoHash = "sha256-Hp7pF+K8HfXhdiAOaZB9xWac04g6jl8g9rnSQM3RAEw=";

  buildInputs = [ ookla-speedtest ];

  postInstall = ''
    mkdir -p $out/usr/lib/systemd/system

    substitute ./systemd/pulse-agent.service $out/usr/lib/systemd/system/pulse-agent.service \
      --replace /usr/local/bin/pulse-agent $out/bin/pulse-agent
  '';

  meta = {
    homepage = "https://gitlab.com/team-olilo/pulse-agent";
    description = "Personal monitoring agent for Pulse: pings independent reference targets and runs periodic speed tests, reported to your MyPulse dashboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jadewilk ];
    mainProgram = "pulse-agent";
    platforms = lib.platforms.linux;
  };
})
