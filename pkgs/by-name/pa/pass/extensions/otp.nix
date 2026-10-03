{
  lib,
  stdenv,
  fetchFromGitHub,
  oath-toolkit,
}:

stdenv.mkDerivation rec {
  pname = "pass-otp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "v${version}";
    hash = "sha256-O3WZFEKh/89MiJnWSCMxqSMGXykANX0e3wymkYbL+DI=";
  };

  buildInputs = [ oath-toolkit ];

  dontBuild = true;

  patchPhase = ''
    sed -i -e 's|OATH=\$(which oathtool)|OATH=${oath-toolkit}/bin/oathtool|' otp.bash
  '';

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
  ];

  meta = {
    description = "Pass extension for managing one-time-password (OTP) tokens";
    homepage = "https://github.com/tadfisher/pass-otp";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      jwiegley
      tadfisher
      toonn
    ];
    platforms = lib.platforms.unix;
  };
}
