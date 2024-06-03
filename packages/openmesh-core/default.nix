{ 
  pkgs
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
}:

pkgs.buildGoModule rec {
  pname = "openmesh-core";
  version = "0.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = "core";
    rev = "55a5e37ef2b750b1b775aff3200c3fc001b163a8";
    sha256 = "1wjmpjrvv4k0c8pjgyacyr1gfr08q1ff1m1hcmnm35z2akz7n5rx"; # Unfinished commit
  };
    
  #vendorHash = lib.fakeHash;
  vendorHash = "sha256-DlbPQgYo/pjTAbI1Fxi7atPxRUtWu5rF2tRtCP/XYTs=";
  doCheck = false;
  outputs = [ "out" "core" ];

    # Move binaries to separate outputs and symlink them back to $out
  postInstall = lib.concatStringsSep "\n" (
    builtins.map (bin: "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/ && 
    cp -r cbft-home $out/bin/cbft-home && cp config.yml $out/bin/config.yml && [cometbft init cmd]"
    ) [ "core" ]
  );


  tags = [ "xnode" "openmesh" ];

  meta = with lib; {
    homepage = "https://openmesh.network/";
    description = "Implementation of an Openmesh Network node";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ harrys522 ];
  };
}
