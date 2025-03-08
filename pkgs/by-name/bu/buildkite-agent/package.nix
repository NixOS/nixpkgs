{
  fetchFromGitHub,
  lib,
  buildGoModule,
  makeWrapper,
  coreutils,
  git,
  openssh,
  bash,
  gnused,
  gnugrep,
  gitUpdater,
  nixosTests,
}:
buildGoModule rec {
  pname = "buildkite-agent";
  version = "3.89.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-5COo5vXecXLhYAy3bcaYvmluFdfEKGgiTbhat8T3AV8=";
  };

  vendorHash = "sha256-iYc/TWiUFdlgoGB4r/L28yhwQG7g+tBG8usB77JJncM=";

  postPatch = ''
    substituteInPlace clicommand/agent_start.go --replace /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  # buildkite-agent expects the `buildVersion` variable to be set to something
  # other than its sentinel, otherwise the agent will not work correctly as of
  # https://github.com/buildkite/agent/pull/3123
  ldflags = [
    "-X github.com/buildkite/agent/v3/version.buildNumber=nix"
  ];

  postInstall = ''
    # Fix binary name
    mv $out/bin/{agent,buildkite-agent}

    # These are runtime dependencies
    wrapProgram $out/bin/buildkite-agent \
      --prefix PATH : '${
        lib.makeBinPath [
          openssh
          git
          coreutils
          gnused
          gnugrep
        ]
      }'
  '';

  passthru = {
    tests.smoke-test = nixosTests.buildkite-agents;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Build runner for buildkite.com";
    longDescription = ''
      The buildkite-agent is a small, reliable, and cross-platform build runner
      that makes it easy to run automated builds on your own infrastructure.
      It’s main responsibilities are polling buildkite.com for work, running
      build jobs, reporting back the status code and output log of the job,
      and uploading the job's artifacts.
    '';
    homepage = "https://buildkite.com/docs/agent";
    license = licenses.mit;
    maintainers = with maintainers; [
      pawelpacana
      zimbatm
      jsoo1
      techknowlogick
    ];
    platforms = with platforms; unix ++ darwin;
  };
}
