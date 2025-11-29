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
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "jj-fzf";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    tag = "v${version}";
    hash = "sha256-aJyKVMg/yI2CmAx5TxN0w670Rq26ESdLzESgh8Jr4nE=";
  };

  nativeBuildInputs = [
    makeWrapper
    pandoc
    installShellFiles
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

    # Generate the manual page
    make doc/jj-fzf.1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install main script
    install -D jj-fzf $out/bin/jj-fzf

    # Install helper scripts and libraries to libexec
    install -D -t $out/libexec/jj-fzf preflight.sh version.sh
    cp -r lib $out/libexec/jj-fzf/

    # Install documentation
    installManPage doc/jj-fzf.1

    runHook postInstall
  '';

  postFixup = ''
    # The main script needs to be able to find the helper scripts in libexec
    substituteInPlace $out/bin/jj-fzf \
      --replace-fail 'readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"' "readonly SCRIPT_DIR=\"$out/libexec/jj-fzf\""

    wrapProgram $out/bin/jj-fzf \
      --prefix PATH : "${lib.makeBinPath buildInputs}"
  '';

  meta = with lib; {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.unix;
  };
}
