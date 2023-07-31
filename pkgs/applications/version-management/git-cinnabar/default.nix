{ stdenv, lib, fetchFromGitHub, cargo, pkg-config, rustPlatform
, bzip2, curl, zlib, zstd, libiconv, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "git-cinnabar";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
    rev = version;
    sha256 = "1Y4zd4rYNRatemDXRMkQQwBJdkfOGfDWk9QBvJOgi7s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config rustPlatform.cargoSetupHook cargo
  ];

  buildInputs = [ bzip2 curl zlib zstd ]
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreServices ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "p85AS2DukUzEbW9UGYmiF3hpnZvPrZ2sRaeA9dU8j/8=";
  };

  ZSTD_SYS_USE_PKG_CONFIG = true;

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -v target/release/git-cinnabar $out/bin
    ln -sv git-cinnabar $out/bin/git-remote-hg
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
