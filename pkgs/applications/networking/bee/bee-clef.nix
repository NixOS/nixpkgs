{ version ? "release", stdenv, lib, fetchFromGitHub, go-ethereum }:

let

  versionSpec = rec {
    unstable = rec {
      pname = "bee-clef-unstable";
      version = "2021-06-24";
      rev = "cc816b56526c575b325122f1b65a20258e30ac2c";
      hash = "sha256:1dr3ghj8l28mq9w03nv1lv2df54c6r5vnqnjksgzji0zb64nf0ja";
    };
    release = rec {
      pname = "bee-clef";
      version = "0.5.0";
      rev = "v${version}";
      hash = "sha256:1dr3ghj8l28mq9w03nv1lv2df54c6r5vnqnjksgzji0zb64nf0ja";
    };
  }.${version};

in

stdenv.mkDerivation rec {
  inherit (versionSpec) pname version;

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee-clef";
    inherit (versionSpec) rev hash;
  };

  buildInputs = [ go-ethereum.clef ];

  clefBinary = "${go-ethereum.clef}/bin/clef";

  patches = [
    ./0001-nix-diff-for-bee-clef.patch
  ];

  dontBuild = true;

  # NOTE we do not package the .service file, because we generate a variable number
  # or instances from the service nix file. it also confuses users, see e.g.:
  # https://github.com/NixOS/nixpkgs/issues/113697
  installPhase = ''
    mkdir -p $out/share/bee-clef/
    substituteAll packaging/bee-clef-service $out/share/bee-clef/bee-clef-service
    substituteAll ${./ensure-clef-account} $out/share/bee-clef/ensure-clef-account
    cp packaging/rules.js packaging/4byte.json $out/share/bee-clef/
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
