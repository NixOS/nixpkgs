{
  stdenv,
  lib,
  fetchFromGitHub,
  runCommand,
  which,
  python3,
  help2man,
  makeWrapper,
  ethtool,
  inetutils,
  iperf,
  iproute2,
  nettools,
  socat,
}:

let
  pyEnv = python3.withPackages (ps: [
    ps.setuptools
    ps.packaging
    ps.distutils
  ]);

  telnet = runCommand "inetutils-telnet" { } ''
    mkdir -p "$out/bin"
    ln -s "${inetutils}"/bin/telnet "$out/bin"
  '';

  generatedPath = lib.makeSearchPath "bin" [
    iperf
    ethtool
    iproute2
    socat
    # mn errors out without a telnet binary
    # pkgs.inetutils brings an undesired ifconfig into PATH see #43105
    nettools
    telnet
  ];

in
stdenv.mkDerivation rec {
  pname = "mininet";
  version = "2.3.1b4";

  outputs = [
    "out"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "mininet";
    repo = "mininet";
    rev = version;
    hash = "sha256-Z7Vbfu0EJ4+rCpckXrt3hgxeB9N2nnyPIXgPBnpV4uw=";
  };

  buildFlags = [ "mnexec" ];
  makeFlags = [ "PREFIX=$(out)" ];

  pythonPath = [ python3.pkgs.setuptools ];
  nativeBuildInputs = [
    help2man
    makeWrapper
    python3.pkgs.wrapPython
  ];

  propagatedBuildInputs = [
    pyEnv
    which
  ];

  installTargets = [
    "install-mnexec"
    "install-manpages"
  ];

  preInstall = ''
    mkdir -p $out $py
    # without --root, install fails
    "${pyEnv.interpreter}" setup.py install \
      --root="/" \
      --prefix="$py" \
      --install-scripts="$out/bin"
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$py $pythonPath"
    wrapProgram "$out/bin/mnexec" \
      --prefix PATH : "${generatedPath}"
    wrapProgram "$out/bin/mn" \
      --prefix PATH : "${generatedPath}"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Emulator for rapid prototyping of Software Defined Networks";
    license = licenses.bsd3;
    platforms = platforms.linux;
    homepage = "https://github.com/mininet/mininet";
    maintainers = with maintainers; [ teto ];
    mainProgram = "mnexec";
  };
}
