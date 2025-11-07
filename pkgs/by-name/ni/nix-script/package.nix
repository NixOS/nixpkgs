{
  lib,
  stdenv,
  haskellPackages,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "nix-script";
  version = "2020-03-23";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-script";
    rev = "7706b45429ff22c35bab575734feb2926bf8840b";
    sha256 = "0yiqljamcj9x8z801bwj7r30sskrwv4rm6sdf39j83jqql1fyq7y";
  };

  strictDeps = true;
  nativeBuildInputs = [
    (haskellPackages.ghcWithPackages (hs: with hs; [ posix-escape ]))
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    ghc -O2 $src/nix-script.hs -o $out/bin/nix-script -odir . -hidir .

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    ln -s $out/bin/nix-script $out/bin/nix-scripti

    runHook postInstall
  '';

  meta = with lib; {
    description = "Shebang for running inside nix-shell";
    homepage = "https://github.com/bennofs/nix-script";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      bennofs
      rnhmjoj
    ];
    platforms = haskellPackages.ghc.meta.platforms;
  };
}
