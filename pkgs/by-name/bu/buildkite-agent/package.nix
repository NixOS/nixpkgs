{ fetchFromGitHub
, lib
, buildGoModule
, makeWrapper
, coreutils
, git
, openssh
, bash
, gnused
, gnugrep
, gitUpdater
, nixosTests
}:
buildGoModule rec {
  pname = "buildkite-agent";
  version = "3.87.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-yCbK6qS7A8K4B3qTZnA6Hl5kOdQ8UCDGmHsVh6LFpbM=";
  };

  vendorHash = "sha256-Ovi1xK+TtWli6ZG0s5Pu0JGAjtbyUWBgiKCBybVbcXk=";

  postPatch = ''
    substituteInPlace clicommand/agent_start.go --replace /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  postInstall = ''
    # Fix binary name
    mv $out/bin/{agent,buildkite-agent}

    # These are runtime dependencies
    wrapProgram $out/bin/buildkite-agent \
      --prefix PATH : '${lib.makeBinPath [ openssh git coreutils gnused gnugrep ]}'
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
    maintainers = with maintainers; [ pawelpacana zimbatm jsoo1 techknowlogick ];
    platforms = with platforms; unix ++ darwin;
  };
}
