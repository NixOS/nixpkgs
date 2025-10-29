{
  lib,
  bashInteractive,
  coreutils,
  fetchFromGitHub,
  fzf,
  gawk,
  gnused,
  jujutsu,
  makeWrapper,
  pandoc,
  python3,
  stdenv,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "jj-fzf";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    rev = "v${version}";
    hash = "sha256-aJyKVMg/yI2CmAx5TxN0w670Rq26ESdLzESgh8Jr4nE=";
  };

  nativeBuildInputs = [
    makeWrapper
    pandoc
  ];

  buildInputs = [
    bashInteractive
    coreutils
    fzf
    gawk
    gnused
    jujutsu
    python3
    util-linux
  ];

  postPatch = ''
    # Fix shebangs in all shell scripts
    patchShebangs --build version.sh preflight.sh jj-fzf

    # Patch scripts in lib directory
    if [ -d lib ]; then
      patchShebangs --build lib
    fi

    # Fix Makefile to use absolute path for env
    substituteInPlace Makefile.mk \
      --replace-fail "/usr/bin/env" "${lib.getExe' coreutils "env"}"
  '';

  buildPhase = ''
    runHook preBuild

    # Ensure all build tools are in PATH
    export PATH=${
      lib.makeBinPath [
        bashInteractive
        coreutils
        fzf
        gawk
        gnused
        jujutsu
        python3
        util-linux
      ]
    }:$PATH

    # Generate the manual page
    make doc/jj-fzf.1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install main script
    install -D jj-fzf $out/bin/jj-fzf

    # Install required dependencies
    install -D preflight.sh $out/bin/preflight.sh
    install -D version.sh $out/bin/version.sh

    # Install lib directory and its contents
    mkdir -p $out/bin/lib
    cp -r lib/* $out/bin/lib/

    # Install documentation
    mkdir -p $out/share/man/man1
    install -D doc/jj-fzf.1 $out/share/man/man1/jj-fzf.1

    # Wrap with dependencies
    wrapProgram $out/bin/jj-fzf \
      --prefix PATH : ${
        lib.makeBinPath [
          bashInteractive
          coreutils
          fzf
          gawk
          gnused
          jujutsu
          python3
          util-linux
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.unix;
  };
}
