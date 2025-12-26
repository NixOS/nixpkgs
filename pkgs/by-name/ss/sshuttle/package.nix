{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  sphinx,
  coreutils,
  iptables,
  net-tools,
  openssh,
  procps,
}:

python3Packages.buildPythonApplication rec {
  pname = "sshuttle";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sshuttle";
    repo = "sshuttle";
    tag = "v${version}";
    hash = "sha256-Rvhh99DO/4J1p0JZJauOnvQZKtZBvxu+7hNnNgsXn2w=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    sphinx
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ];

  postBuild = ''
    make man -C docs
  '';

  postInstall = ''
    installManPage docs/_build/man/*

    wrapProgram $out/bin/sshuttle \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            coreutils
            openssh
            procps
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            iptables
            net-tools
          ]
        )
      }" \
  '';

  meta = {
    description = "Transparent proxy server that works as a poor man's VPN";
    mainProgram = "sshuttle";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2.7, Python 3.5 or later at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    homepage = "https://github.com/sshuttle/sshuttle";
    changelog = "https://github.com/sshuttle/sshuttle/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      carlosdagos
    ];
  };
}
