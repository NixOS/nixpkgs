{
  lib,
  stdenv,
  fetchFromGitHub,
  oath-toolkit,
}:

stdenv.mkDerivation {
  pname = "pass-otp";
  version = "unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "7bb50dbc4b6073f12f40be66a5ee371b9652a646";
    sha256 = "sha256-dmdZIuDZQLIF7T3crLKQeQ6bqZtb6Wd+Fd5Z7aY0Azc=";
  };

  buildInputs = [ oath-toolkit ];

  dontBuild = true;

  patchPhase = ''
    sed -i -e 's|OATH=\$(command -v oathtool)|OATH=${oath-toolkit}/bin/oathtool|' otp.bash
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
