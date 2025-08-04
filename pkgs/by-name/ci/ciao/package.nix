{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ciao";
  version = "1.25.0-m1";
  src = fetchFromGitHub {
    owner = "ciao-lang";
    repo = "ciao";
    rev = "v${version}";
    sha256 = "sha256-jsHz50+R/bs19ees3kKYalYk72ET9eSAAUY7QogI0go=";
  };

  configurePhase = ''
    ./ciao-boot.sh configure --instype=global --prefix=$prefix
  '';

  buildPhase = ''
    ./ciao-boot.sh build
  '';

  installPhase = ''
    runHook preInstall

    ./ciao-boot.sh install

    runHook postInstall
  '';

  # Replace broken symlinks with actual headers to avoid dead links
  postInstall =
    let
      ver = lib.head (lib.split "-" version);
    in
    ''
      rm -rf $out/ciao/${ver}/build/eng/ciaoengine/include/ciao/ $out/ciao/${ver}/build/eng/ciaoengine/include/ciao_prolog.h
      cp -r core/engine $out/ciao/${ver}/build/eng/ciaoengine/include/ciao/
      cp core/engine/ciao_prolog.h $out/ciao/${ver}/build/eng/ciaoengine/include/ciao_prolog.h
    '';

  meta = with lib; {
    homepage = "https://ciao-lang.org/";
    description = "General purpose, multi-paradigm programming language in the Prolog family";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ suhr ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/ciao.x86_64-darwin
  };
}
