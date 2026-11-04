{ lib
, stdenv
, fetchFromGitHub
, python3
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "nxmgr";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "homek1llua";
    repo = "nxmgr";
    rev = "v${version}";
    hash = "sha256-9RxsPNakaTmROoNUZFcq2sGqIWWv5AIwEv58HFewp4M=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/nxmgr $out/bin $out/share/bash-completion/completions

    cp -r nixos_pkg main.py $out/lib/nxmgr/
    cp completions/pkg.bash $out/share/bash-completion/completions/pkg

    cat << 'EOF' > $out/bin/pkg
    #!/bin/sh
    exec @python@/bin/python3 @out@/lib/nxmgr/main.py "$@"
    EOF
    substituteInPlace $out/bin/pkg \
      --subst-var out \
      --subst-var-by python ${python3}
    chmod +x $out/bin/pkg

    ln -s pkg $out/bin/nx

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fast, declarative CLI package manager for NixOS";
    homepage = "https://github.com/homek1llua/nxmgr";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "pkg";
  };
}