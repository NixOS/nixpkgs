{ stdenv, lib, fetchFromGitHub, autoconf, makeWrapper
, curl, libiconv, mercurial, zlib
, CoreServices
}:

let
  python3 = mercurial.python;
in

stdenv.mkDerivation rec {
  pname = "git-cinnabar";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
    rev = version;
    sha256 = "sha256-64ofKGeHwCqiZHOA6MrYrN2eV/qqClcjerDuSqsjKDg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoconf makeWrapper ];
  buildInputs = [ curl zlib ] ++ lib.optionals stdenv.isDarwin [ libiconv CoreServices ];

  # Ignore submodule status failing due to no git in environment.
  makeFlags = [ "SUBMODULE_STATUS=yes" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    install git-cinnabar-helper $out/bin
    install git-cinnabar git-remote-hg $out/libexec
    cp -r cinnabar mercurial $out/libexec

    for pythonBin in git-cinnabar git-remote-hg; do
        makeWrapper $out/libexec/$pythonBin $out/bin/$pythonBin \
            --prefix PATH : ${lib.getBin python3}/bin \
            --set PYTHONPATH ${mercurial}/${python3.sitePackages}
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/glandium/git-cinnabar";
    description = "git remote helper to interact with mercurial repositories";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
  };
}
