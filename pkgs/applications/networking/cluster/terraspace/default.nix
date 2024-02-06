{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper, ruby }:
let
  rubyEnv = bundlerEnv {
    inherit ruby;
    name = "terraspace";
    gemdir  = ./.;
  };
in stdenv.mkDerivation {
  pname = "terraspace";
  version = (import ./gemset.nix).terraspace.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/terraspace $out/bin/terraspace
    wrapProgram $out/bin/terraspace \
      --prefix PATH : ${lib.makeBinPath [ rubyEnv.ruby ]}
  '';

  passthru.updateScript = bundlerUpdateScript "terraspace";

  meta = with lib; {
    description = "Terraform framework that provides an organized structure, and keeps your code DRY";
    homepage    = "https://github.com/boltops-tools/terraspace";
    license     = licenses.asl20;
    platforms   = ruby.meta.platforms;
    maintainers = with maintainers; [ mislavzanic ];
  };
}
