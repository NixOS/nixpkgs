{ version ? "release", stdenv, lib, fetchFromGitHub, go-ethereum }:

stdenv.mkDerivation rec {
  pname = "bee-clef";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee-clef";
    rev = "refs/tags/v${version}";
    sha256 = "1sfwql0kvnir8b9ggpqcyc0ar995gxgfbhqb1xpfzp6wl0g3g4zz";
  };

  buildInputs = [ go-ethereum ];

  clefBinary = "${go-ethereum}/bin/clef";

  patches = [
    ./0001-clef-service-accept-default-CONFIGDIR-from-the-envir.patch
    ./0002-nix-diff-for-substituteAll.patch
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/share/bee-clef/
    mkdir -p $out/lib/systemd/system/
    cp packaging/bee-clef.service $out/lib/systemd/system/
    substituteAll packaging/bee-clef-service $out/share/bee-clef/bee-clef-service
    substituteAll ${./ensure-clef-account} $out/share/bee-clef/ensure-clef-account
    substituteAll packaging/bee-clef-keys $out/bin/bee-clef-keys
    cp packaging/rules.js packaging/4byte.json $out/share/bee-clef/
    chmod +x $out/bin/bee-clef-keys
    chmod +x $out/share/bee-clef/bee-clef-service
    chmod +x $out/share/bee-clef/ensure-clef-account
    patchShebangs $out/
  '';

  meta = with lib; {
    # homepage = "https://gateway.ethswarm.org/bzz/docs.swarm.eth/docs/installation/bee-clef/";
    homepage = "https://docs.ethswarm.org/docs/installation/bee-clef";
    description = "External signer for Ethereum Swarm Bee";
    longDescription = ''
      clef is go-ethereum's external signer.

      bee-clef is a package that starts up a vanilla clef instance as a systemd service,
      but configured in such a way that is suitable for bee (relaxed security for
      automated operation).

      This package contains the files necessary to run the bee-clef service.
    '';
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ attila-lendvai ];
    platforms = go-ethereum.meta.platforms;
  };
}
