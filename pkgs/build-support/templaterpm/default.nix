{lib, stdenv, makeWrapper, python, toposort, rpm}:

stdenv.mkDerivation {
  pname = "nix-template-rpm";
  version = "0.1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python toposort rpm ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${./nix-template-rpm.py} $out/bin/nix-template-rpm
    wrapProgram $out/bin/nix-template-rpm \
      --set PYTHONPATH "${rpm}/lib/${python.libPrefix}/site-packages":"${toposort}/lib/${python.libPrefix}/site-packages"
    '';

  meta = with lib; {
    description = "Create templates of nix expressions from RPM .spec files";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    hydraPlatforms = [];
  };
}
