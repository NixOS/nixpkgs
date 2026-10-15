{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "pass-genphrase";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "congma";
    repo = "pass-genphrase";
    rev = version;
    hash = "sha256-3SrnfN/F1m+RdgLUFNinEN4v41s83Er38SGES6VwrgU=";
  };

  dontBuild = true;

  buildInputs = [ python3 ];

  installTargets = [ "globalinstall" ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    substituteInPlace $out/lib/password-store/extensions/genphrase.bash \
      --replace '$EXTENSIONS' "$out/lib/password-store/extensions/"
  '';

  meta = {
    description = "Pass extension that generates memorable passwords";
    homepage = "https://github.com/congma/pass-genphrase";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ seqizz ];
    platforms = lib.platforms.unix;
  };
}
