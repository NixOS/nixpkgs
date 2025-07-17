{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ssh-agents";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kalbasit";
    repo = "ssh-agents";
    rev = "v${version}";
    sha256 = "1l09zy87033v7hd17lhkxikwikqz5nj9x6c2w80rqpad4lp9ihwz";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "ssh-agents capable of spawning and maintaining multiple ssh-agents across terminals";
    longDescription = ''
      The SSH agent is usually spawned by running eval $(ssh-agent), however this
      spawns a new SSH agent at every invocation. This project provides an
      ssh-agent wrapper called ssh-agents that is capable of spawning an SSH
      agent and caching the environment variables for later invocation.

      Features
      - One SSH agent across all terminals
      - Add all un-encrypted SSH keys to the agent upon spawning. Please note
        that encrypted SSH keys can only be added via ssh-add after having
        started the agent.
      - Ability to have different keys in different agents for security purposes.
      - Multiple SSH agents
      - To use multi-SSH agents, start ssh agent with the --name flag. The
        given name is expected to be a folder under ~/.ssh/name containing the
        keys to include in the agent.
    '';
    homepage = "https://github.com/kalbasit/ssh-agents";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.unix;
    mainProgram = "ssh-agents";
  };
}
