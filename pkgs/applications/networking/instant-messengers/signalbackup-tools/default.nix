{ lib, stdenv, darwin, fetchFromGitHub, openssl, sqlite }:

<<<<<<< HEAD
(if stdenv.isDarwin then darwin.apple_sdk_11_0.llvmPackages_14.stdenv else stdenv).mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20230907";
=======
(if stdenv.isDarwin then darwin.apple_sdk_11_0.clang14Stdenv else stdenv).mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20230510";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Y0fCWy2hrUcsH1ru96Y5TezglUaDrw4pcoWmLjBojxs=";
=======
    hash = "sha256-EsFF9fPpHfVmbLm2hRpcJBmwfovfK4CV3LukrG9nP3U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs BUILDSCRIPT_MULTIPROC.bash44
  '';

  buildInputs = [ openssl sqlite ];

  buildPhase = ''
    runHook preBuild
    ./BUILDSCRIPT_MULTIPROC.bash44${lib.optionalString stdenv.isDarwin " --config nixpkgs-darwin"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
