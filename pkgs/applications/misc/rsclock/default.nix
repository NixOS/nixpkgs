{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fpidswkgpf9yr4vxqn38livz6r3z5i0lhg7ngj9f1ki4yqxn9zh";
  };
   
  cargoSha256 = "1m0lm8xh1qp0cbx870xy2m0bv047mb00vcwzq7r5gxqx8n61qm4n";

  meta = with stdenv.lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
    platforms = platforms.all;
  };
}

