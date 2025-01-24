{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  asciidoctor,
  coreutils,
  gawk,
  glibc,
  util-linux,
  bash,
  makeBinaryWrapper,
  doas-sudo-shim,
}:

stdenv.mkDerivation rec {
  pname = "doas-sudo-shim";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "doas-sudo-shim";
    rev = "v${version}";
    sha256 = "QYVqGxeWC7Tiz8aNY/LukwG4EW0km/RunGEfkzY/A38=";
  };

  nativeBuildInputs = [
    asciidoctor
    makeBinaryWrapper
  ];
  buildInputs = [
    bash
    coreutils
    gawk
    glibc
    util-linux
  ];

  dontConfigure = true;
  dontBuild = true;

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=\"\""
  ];

  postInstall = ''
    wrapProgram $out/bin/sudo \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          gawk
          glibc
          util-linux
        ]
      }
  '';

  passthru.tests = {
    helpTest = runCommand "${pname}-helpTest" { } ''
      ${doas-sudo-shim}/bin/sudo -h > $out
      grep -q "Execute a command as another user using doas(1)" $out
    '';
  };

  meta = with lib; {
    description = "Shim for the sudo command that utilizes doas";
    homepage = "https://github.com/jirutka/doas-sudo-shim";
    license = licenses.isc;
    mainProgram = "sudo";
    maintainers = with maintainers; [ dsuetin ];
    platforms = platforms.linux;
  };
}
