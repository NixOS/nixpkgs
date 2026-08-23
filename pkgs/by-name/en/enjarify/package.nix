{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enjarify";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "enjarify";
    rev = finalAttrs.version;
    sha256 = "sha256-VDBC5n2jWLNJsilX+PV1smL5JeBDj23jYFRwdObXwYs=";
  };

  installPhase = ''
    pypath="$out/${python3.sitePackages}"
    mkdir -p $out/bin $pypath
    mv enjarify $pypath

    cat << EOF > $out/bin/enjarify
    #!${runtimeShell}
    export PYTHONPATH=$pypath
    exec ${python3.interpreter} -O -m enjarify.main "\$@"
    EOF
    chmod +x $out/bin/enjarify
  '';

  meta = {
    description = "Tool for translating Dalvik bytecode to equivalent Java bytecode";
    homepage = "https://github.com/google/enjarify/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "enjarify";
  };
})
